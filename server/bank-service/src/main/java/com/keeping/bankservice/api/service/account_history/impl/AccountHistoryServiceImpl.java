package com.keeping.bankservice.api.service.account_history.impl;

import com.keeping.bankservice.api.service.account.AccountService;
import com.keeping.bankservice.api.service.account.dto.DepositMoneyDto;
import com.keeping.bankservice.api.service.account.dto.WithdrawMoneyDto;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountDetailValidationDto;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import com.keeping.bankservice.domain.account.Account;
import com.keeping.bankservice.domain.account_history.AccountHistory;
import com.keeping.bankservice.domain.account_history.LargeCategory;
import com.keeping.bankservice.domain.account_history.repository.AccountHistoryQueryRepository;
import com.keeping.bankservice.domain.account_history.repository.AccountHistoryRepository;
import com.keeping.bankservice.global.exception.InvalidRequestException;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

import static com.keeping.bankservice.domain.account_history.LargeCategory.*;

@Service
@Transactional
@RequiredArgsConstructor
public class AccountHistoryServiceImpl implements AccountHistoryService {

    private final AccountService accountService;
    private final AccountHistoryRepository accountHistoryRepository;
    private final AccountHistoryQueryRepository accountHistoryQueryRepository;

    @Override
    public Long addAccountHistory(String memberKey, AddAccountHistoryDto dto) throws URISyntaxException {
        Account account = null;

        // 입금 상황
        if(dto.isType()) {
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

        // 장소의 위도, 경도, 카테고리 가져오기
        Map keywordResponse = useKakaoLocalApi(true, dto.getStoreName());
        Map addressResponse = useKakaoLocalApi(false, dto.getAddress());

        LargeCategory largeCategory = null;
        String categoryType = null;
        try {
            categoryType = ((LinkedHashMap) ((ArrayList) keywordResponse.get("documents")).get(0)).get("category_group_code").toString();
            largeCategory = mappingCategory(categoryType);
        }
        catch(NullPointerException e) {
            categoryType = "ETC";
        }

        Double latitude = null, longitude = null;
        try {
            latitude = Double.parseDouble((String) ((LinkedHashMap) ((LinkedHashMap) ((ArrayList) addressResponse.get("documents")).get(0)).get("address")).get("y"));
            longitude = Double.parseDouble((String) ((LinkedHashMap) ((LinkedHashMap) ((ArrayList) addressResponse.get("documents")).get(0)).get("address")).get("x"));
        }
        catch(NullPointerException e) {
            latitude = null;
            longitude = null;
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

        if(!accountHistory.getAccount().getMemberKey().equals(memberKey)) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "접근 권한이 없습니다.");
        }

        // 쪼개기 가능한 금액보다 쪼갤 금액이 큰 경우
        if(accountHistory.getRemain() < dto.getMoney()) {
            throw new InvalidRequestException("400", HttpStatus.BAD_REQUEST, "쪼개기 가능한 금액보다 큽니다.");
        }

        accountHistory.addAccountDetail(dto.getMoney());

        return accountHistory;
    }

    private Map useKakaoLocalApi(boolean flag, String value) {
        RestTemplate restTemplate = new RestTemplate();

        final HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK db388e6b11004c2105b5ce40ac21b2a0");

        // 헤더를 넣은 HttpEntity 생성
        final HttpEntity<String> entity = new HttpEntity<String>(headers);

        URI targetUrl = null;
        if(flag) {
            targetUrl = UriComponentsBuilder
                    .fromUriString("https://dapi.kakao.com/v2/local/search/keyword.json") // 기본 url
                    .queryParam("query", value) // 인자
                    .queryParam("size", 1)
                    .build()
                    .encode(StandardCharsets.UTF_8) // 인코딩
                    .toUri();
        }
        else {
            targetUrl = UriComponentsBuilder
                    .fromUriString("https://dapi.kakao.com/v2/local/search/address.json") // 기본 url
                    .queryParam("query", value) // 인자
                    .queryParam("size", 1)
                    .build()
                    .encode(StandardCharsets.UTF_8) // 인코딩
                    .toUri();
        }

        if(targetUrl != null) {
            ResponseEntity<Map> result = restTemplate.exchange(targetUrl, HttpMethod.GET, entity, Map.class);
            return result.getBody(); // 내용 반환
        }
        return null;
    }

    private LargeCategory mappingCategory(String categoryType) {
        switch(categoryType) {
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
