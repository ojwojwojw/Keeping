package com.keeping.bankservice.api.service.account_history.impl;

import com.keeping.bankservice.api.controller.account_history.response.ShowAccountHistoryResponse;
import com.keeping.bankservice.api.controller.account_history.response.ShowChildHistoryResponse;
import com.keeping.bankservice.api.controller.feign_client.MemberFeignClient;
import com.keeping.bankservice.api.controller.feign_client.response.MemberKeyResponse;
import com.keeping.bankservice.api.service.account.AccountService;
import com.keeping.bankservice.api.service.account.dto.DepositMoneyDto;
import com.keeping.bankservice.api.service.account.dto.WithdrawMoneyDto;
import com.keeping.bankservice.api.service.account_detail.dto.ShowAccountDetailDto;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountDetailValidationDto;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import com.keeping.bankservice.api.service.account_history.dto.ShowAccountHistoryDto;
import com.keeping.bankservice.api.service.account_history.dto.TransferMoneyDto;
import com.keeping.bankservice.domain.account.Account;
import com.keeping.bankservice.domain.account.repository.AccountRepository;
import com.keeping.bankservice.domain.account_detail.SmallCategory;
import com.keeping.bankservice.domain.account_detail.repository.AccountDetailQueryRepository;
import com.keeping.bankservice.domain.account_history.AccountHistory;
import com.keeping.bankservice.domain.account_history.LargeCategory;
import com.keeping.bankservice.domain.account_history.repository.AccountHistoryQueryRepository;
import com.keeping.bankservice.domain.account_history.repository.AccountHistoryRepository;
import org.springframework.core.env.Environment;
import com.keeping.bankservice.global.exception.InvalidRequestException;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import com.keeping.bankservice.global.exception.NotFoundException;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import static com.keeping.bankservice.domain.account_history.LargeCategory.*;

@Service
@Transactional
public class AccountHistoryServiceImpl implements AccountHistoryService {

    private final AccountService accountService;
    private final AccountRepository accountRepository;
    private final AccountHistoryRepository accountHistoryRepository;
    private final AccountHistoryQueryRepository accountHistoryQueryRepository;
    private final AccountDetailQueryRepository accountDetailQueryRepository;
    private final MemberFeignClient memberFeignClient;
    private final Environment env;
    private String kakaoAk;

    public AccountHistoryServiceImpl(AccountService accountService, AccountRepository accountRepository, AccountHistoryRepository accountHistoryRepository, AccountHistoryQueryRepository accountHistoryQueryRepository, AccountDetailQueryRepository accountDetailQueryRepository, MemberFeignClient memberFeignClient, Environment env) {
        this.accountService = accountService;
        this.accountRepository = accountRepository;
        this.accountHistoryRepository = accountHistoryRepository;
        this.accountHistoryQueryRepository = accountHistoryQueryRepository;
        this.accountDetailQueryRepository = accountDetailQueryRepository;
        this.memberFeignClient = memberFeignClient;
        this.env = env;
        this.kakaoAk = this.env.getProperty("kakao.api");
    }


    @Override
    public Long addAccountHistory(String memberKey, AddAccountHistoryDto dto) throws URISyntaxException {
        Account account = null;

        // 입금 상황
        if (dto.isType()) {
            DepositMoneyDto depositMoneyDto = DepositMoneyDto.toDto(dto.getAccountNumber(), dto.getMoney());

            // 계좌의 잔액 갱신
            account = accountService.depositMoney(memberKey, depositMoneyDto);
        }
        // 출금 상황
        else {
            WithdrawMoneyDto withdrawMoneyDto = WithdrawMoneyDto.toDto(dto.getAccountNumber(), dto.getMoney());

            // 계좌의 잔액 갱신
            account = accountService.withdrawMoney(memberKey, withdrawMoneyDto);
        }

        LargeCategory largeCategory = ETC;
        String categoryType = null;

        if (dto.getStoreName().equals("저금통 저금") || dto.getStoreName().equals("용돈 지급") || dto.getStoreName().equals("용돈")) {
            largeCategory = BANK;
        } else if (dto.getStoreName() != null) {
            // 장소의 위도, 경도, 카테고리 가져오기
            Map keywordResponse = useKakaoLocalApi(true, dto.getStoreName());
            try {
                categoryType = ((LinkedHashMap) ((ArrayList) keywordResponse.get("documents")).get(0)).get("category_group_code").toString();
                largeCategory = mappingCategory(categoryType);
            } catch (NullPointerException e) {
                categoryType = "ETC";
            }
        }

        Double latitude = null, longitude = null;

        if (dto.getAddress() != null && !dto.getAddress().equals("")) {
            Map addressResponse = useKakaoLocalApi(false, dto.getAddress());
            try {
                latitude = Double.parseDouble((String) ((LinkedHashMap) ((LinkedHashMap) ((ArrayList) addressResponse.get("documents")).get(0)).get("address")).get("y"));
                longitude = Double.parseDouble((String) ((LinkedHashMap) ((LinkedHashMap) ((ArrayList) addressResponse.get("documents")).get(0)).get("address")).get("x"));
            } catch (NullPointerException e) {
                latitude = null;
                longitude = null;
            }
        }

        // 새로운 거래 내역 등록
        AccountHistory accountHistory = AccountHistory.toAccountHistory(account, dto.getStoreName(), dto.isType(), dto.getMoney(), account.getBalance(), dto.getMoney(), largeCategory, false, dto.getAddress(), latitude, longitude);
        AccountHistory saveAccountHistory = accountHistoryRepository.save(accountHistory);

        return saveAccountHistory.getId();
    }

    @Override
    public AccountHistory addAccountDetail(String memberKey, AddAccountDetailValidationDto dto) {
        AccountHistory accountHistory = accountHistoryRepository.findById(dto.getAccountHistoryId())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 거래 내역이 존재하지 않습니다."));

        if (!accountHistory.getAccount().getMemberKey().equals(memberKey)) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "접근 권한이 없습니다.");
        }

        // 쪼개기 가능한 금액보다 쪼갤 금액이 큰 경우
        if (accountHistory.getRemain() < dto.getMoney()) {
            throw new InvalidRequestException("400", HttpStatus.BAD_REQUEST, "쪼개기 가능한 금액보다 큽니다.");
        }

        accountHistory.addAccountDetail(dto.getMoney());

        return accountHistory;
    }

    @Override
    public Map<String, List<ShowAccountHistoryResponse>> showAccountHistory(String memberKey, String targetKey, String accountNumber) {
        // TODO: 두 고유 번호가 부모-자식 관계인지 확인하는 부분 필요
        // TODO: 계좌가 존재하는지 확인하고, 소유자를 확인하는 검사 필요

        List<ShowAccountHistoryDto> result = accountHistoryQueryRepository.showAccountHistories(targetKey, accountNumber);

        Comparator<String> comparator = Comparator.reverseOrder();
        Map<String, List<ShowAccountHistoryResponse>> response = new TreeMap<>(comparator);

        for (ShowAccountHistoryDto dto : result) {
            ShowAccountHistoryResponse showAccountHistoryResponse = null;

            if (dto.isDetailed()) {
                List<ShowAccountDetailDto> detailResult = accountDetailQueryRepository.showAccountDetailes(dto.getId(), targetKey);

                if (dto.getRemain() != 0) {
                    ShowAccountDetailDto extraDetailDto = ShowAccountDetailDto.toDto(-1l, "남은 금액", dto.getRemain(), SmallCategory.ETC);
                    detailResult.add(extraDetailDto);
                }

                showAccountHistoryResponse = ShowAccountHistoryResponse.toResponse(dto, detailResult);
            } else {
                showAccountHistoryResponse = ShowAccountHistoryResponse.toResponse(dto, null);
            }

            String date = dto.getCreatedDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

            if (!response.containsKey(date)) {
                response.put(date, new ArrayList<ShowAccountHistoryResponse>());
            }

            response.get(date).add(showAccountHistoryResponse);
        }

        return response;
    }

    @Override
    public Map<String, List<ShowAccountHistoryResponse>> showAccountDailyHistory(String memberKey, String targetKey, String accountNumber, String date, String type) {
        // TODO: 두 고유 번호가 부모-자식 관계인지 확인하는 부분 필요
        // TODO: 계좌가 존재하는지 확인하고, 소유자를 확인하는 검사 필요

        LocalDate localDate = LocalDate.parse(date);
        LocalDateTime startDateTime = localDate.atStartOfDay();
        LocalDateTime endDateTime = localDate.atTime(LocalTime.MAX);

        List<ShowAccountHistoryDto> result = accountHistoryQueryRepository.showAccountDailyHistories(targetKey, accountNumber, startDateTime, endDateTime, type);

        Map<String, List<ShowAccountHistoryResponse>> response = new HashMap<>();

        for (ShowAccountHistoryDto dto : result) {
            ShowAccountHistoryResponse showAccountHistoryResponse = null;

            if (dto.isDetailed()) {
                List<ShowAccountDetailDto> detailResult = accountDetailQueryRepository.showAccountDetailes(dto.getId(), targetKey);

                if (dto.getRemain() != 0) {
                    ShowAccountDetailDto extraDetailDto = ShowAccountDetailDto.toDto(-1l, "남은 금액", dto.getRemain(), SmallCategory.ETC);
                    detailResult.add(extraDetailDto);
                }

                showAccountHistoryResponse = ShowAccountHistoryResponse.toResponse(dto, detailResult);
            } else {
                showAccountHistoryResponse = ShowAccountHistoryResponse.toResponse(dto, null);
            }

            if (!response.containsKey(date)) {
                response.put(date, new ArrayList<ShowAccountHistoryResponse>());
            }

            response.get(date).add(showAccountHistoryResponse);
        }

        return response;
    }

    @Override
    public Map<String, List<ShowAccountHistoryResponse>> showAccountHistoryRoute(String memberKey, String targetKey, String accountNumber, String date) {
        // TODO: 두 고유 번호가 부모-자식 관계인지 확인하는 부분 필요
        // TODO: 계좌가 존재하는지 확인하고, 소유자를 확인하는 검사 필요

        LocalDate localDate = LocalDate.parse(date);
        LocalDateTime startDateTime = localDate.atStartOfDay();
        LocalDateTime endDateTime = localDate.atTime(LocalTime.MAX);

        List<ShowAccountHistoryDto> result = accountHistoryQueryRepository.showAccountDailyHistories(targetKey, accountNumber, startDateTime, endDateTime, "WITHDRAW");

        Map<String, List<ShowAccountHistoryResponse>> response = new HashMap<>();

        for (ShowAccountHistoryDto dto : result) {
            if (dto.getLatitude() != null && dto.getLongitude() != null) {
                ShowAccountHistoryResponse showAccountHistoryResponse = null;

                if (dto.isDetailed()) {
                    List<ShowAccountDetailDto> detailResult = accountDetailQueryRepository.showAccountDetailes(dto.getId(), targetKey);

                    if (dto.getRemain() != 0) {
                        ShowAccountDetailDto extraDetailDto = ShowAccountDetailDto.toDto(-1l, "남은 금액", dto.getRemain(), SmallCategory.ETC);
                        detailResult.add(extraDetailDto);
                    }

                    showAccountHistoryResponse = ShowAccountHistoryResponse.toResponse(dto, detailResult);
                } else {
                    showAccountHistoryResponse = ShowAccountHistoryResponse.toResponse(dto, null);
                }

                if (!response.containsKey(date)) {
                    response.put(date, new ArrayList<ShowAccountHistoryResponse>());
                }

                response.get(date).add(showAccountHistoryResponse);
            }
        }

        return response;
    }

    @Override
    public Long countMonthExpense(String memberKey, String targetKey, String date) {
        // TODO: 두 고유 번호가 부모-자식 관계인지 확인하는 부분 필요

        Optional<List<Account>> accountList = accountRepository.findByMemberKey(targetKey);

        if (accountList.isEmpty()) {
            return 0l;
        }

        List<Account> accounts = accountList.get();

        LocalDate startDate = LocalDate.parse(date + "-01", DateTimeFormatter.ISO_DATE);
        LocalDateTime startDateTime = startDate.atStartOfDay();
        LocalDateTime endDateTime = startDate.plusMonths(1).atStartOfDay().minusSeconds(1);

        Long total = 0l;
        for (Account account : accounts) {
            Long result = accountHistoryQueryRepository.countMonthExpense(account, startDateTime, endDateTime);
            total += result;
        }

        return total;
    }

    @Override
    public void transferMoney(String memberKey, TransferMoneyDto dto) throws URISyntaxException {
        // TODO: 두 고유 번호가 부모-자식 관계인지 확인하는 부분 필요

        // 부모 계좌에서 출금
        List<Account> parentAccountList = accountRepository.findByMemberKey(memberKey)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당 회원의 계좌가 존재하지 않습니다."));

        Account parentAccount = parentAccountList.get(0);
        AddAccountHistoryDto parentAccountHistoryDto = AddAccountHistoryDto.toDto(parentAccount.getAccountNumber(), "용돈 지급", false, Long.valueOf(dto.getMoney()), "");
        addAccountHistory(memberKey, parentAccountHistoryDto);

        // 자식 계좌로 입금
        List<Account> childAccountList = accountRepository.findByMemberKey(dto.getChildKey())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당 회원의 계좌가 존재하지 않습니다."));

        Account childAccount = childAccountList.get(0);
        AddAccountHistoryDto childAccountHistoryDto = AddAccountHistoryDto.toDto(childAccount.getAccountNumber(), "용돈", true, Long.valueOf(dto.getMoney()), "");
        addAccountHistory(dto.getChildKey(), childAccountHistoryDto);
    }

    @Override
    public List<ShowChildHistoryResponse> showChildHistory() {
        List<ShowChildHistoryResponse> response = new ArrayList<>();

        List<MemberKeyResponse> memberKeyResponseList = memberFeignClient.getChildMemberKey().getResultBody();

        LocalDate today = LocalDate.now();
        LocalDateTime startDateTime = today.minusDays(1).atStartOfDay();
        LocalDateTime endDateTime = today.minusDays(1).atTime(LocalTime.MAX);

        System.out.println("[날짜 출력] startDateTime: " + startDateTime + ", endDateTime: " + endDateTime);

        for(MemberKeyResponse memberKeyResponse : memberKeyResponseList) {
            String childKey = memberKeyResponse.getChildKey();

            List<ShowAccountHistoryResponse> transactionList = new ArrayList<>();
            List<ShowAccountHistoryDto> result = accountHistoryQueryRepository.showAccountDailyHistories(childKey, null, startDateTime, endDateTime, "ALL");

            for (ShowAccountHistoryDto dto : result) {
                ShowAccountHistoryResponse showAccountHistoryResponse = null;

                if (dto.isDetailed()) {
                    List<ShowAccountDetailDto> detailResult = accountDetailQueryRepository.showAccountDetailes(dto.getId(), childKey);

                    if (dto.getRemain() != 0) {
                        ShowAccountDetailDto extraDetailDto = ShowAccountDetailDto.toDto(-1l, "남은 금액", dto.getRemain(), SmallCategory.ETC);
                        detailResult.add(extraDetailDto);
                    }

                    showAccountHistoryResponse = ShowAccountHistoryResponse.toResponse(dto, detailResult);
                } else {
                    showAccountHistoryResponse = ShowAccountHistoryResponse.toResponse(dto, null);
                }

                transactionList.add(showAccountHistoryResponse);
            }

            ShowChildHistoryResponse showChildHistoryResponse = ShowChildHistoryResponse.toResponse(childKey, memberKeyResponse.getParentKey(), transactionList);
            response.add((showChildHistoryResponse));
        }

        return response;
    }

    private Map useKakaoLocalApi(boolean flag, String value) {
        RestTemplate restTemplate = new RestTemplate();

        final HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + kakaoAk);

        // 헤더를 넣은 HttpEntity 생성
        final HttpEntity<String> entity = new HttpEntity<String>(headers);

        URI targetUrl = null;
        if (flag) {
            targetUrl = UriComponentsBuilder
                    .fromUriString("https://dapi.kakao.com/v2/local/search/keyword.json") // 기본 url
                    .queryParam("query", value) // 인자
                    .queryParam("size", 1)
                    .build()
                    .encode(StandardCharsets.UTF_8) // 인코딩
                    .toUri();
        } else {
            targetUrl = UriComponentsBuilder
                    .fromUriString("https://dapi.kakao.com/v2/local/search/address.json") // 기본 url
                    .queryParam("query", value) // 인자
                    .queryParam("size", 1)
                    .build()
                    .encode(StandardCharsets.UTF_8) // 인코딩
                    .toUri();
        }

        if (targetUrl != null) {
            ResponseEntity<Map> result = restTemplate.exchange(targetUrl, HttpMethod.GET, entity, Map.class);
            return result.getBody(); // 내용 반환
        }
        return null;
    }

    private LargeCategory mappingCategory(String categoryType) {
        switch (categoryType) {
            case "MT1":
                return MART;
            case "CS2":
                return CONVENIENCE;
            case "SC4":
                return SCHOOL;
            case "AC5":
                return ACADEMY;
            case "PK6":
                return PARKING;
            case "SW8":
                return SUBWAY;
            case "BK9":
                return BANK;
            case "CT1":
                return CULTURE;
            case "AT4":
                return TOUR;
            case "FD6":
                return FOOD;
            case "CE7":
                return CAFE;
            case "HP8":
                return HOSPITAL;
            case "PM9":
                return PHARMACY;
        }
        return ETC;
    }
}
