package com.keeping.bankservice.api.service.account_history.impl;

import com.keeping.bankservice.api.service.account.AccountService;
import com.keeping.bankservice.api.service.account.dto.DepositMoneyDto;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import com.keeping.bankservice.api.service.account_history.dto.KeywordResponseDto;
import com.keeping.bankservice.domain.account.Account;
import com.keeping.bankservice.domain.account_history.AccountHistory;
import com.keeping.bankservice.domain.account_history.repository.AccountHistoryQueryRepository;
import com.keeping.bankservice.domain.account_history.repository.AccountHistoryRepository;
import lombok.RequiredArgsConstructor;
import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.util.UriComponentsBuilder;
import reactor.core.publisher.Mono;

import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
@Transactional
@RequiredArgsConstructor
public class AccountHistoryServiceImpl implements AccountHistoryService {

    private final AccountService accountService;
    private final AccountHistoryRepository accountHistoryRepository;
    private final AccountHistoryQueryRepository accountHistoryQueryRepository;

    @Override
    public Long addAccountHistory(String memberKey, AddAccountHistoryDto dto) throws URISyntaxException {

        // 입금 상황
        if(dto.isType()) {
            DepositMoneyDto  depositMoneyDto = DepositMoneyDto.toDto(dto.getAccountNumber(), dto.getMoney());

            // 계좌의 잔액 갱신
            Account account = accountService.depositMoney(memberKey, depositMoneyDto);

            // 장소의 위도, 경도, 카테고리 가져오기
            Map keywordResponse = useKakaoLocalApi(true, dto.getStoreName());
            String category = ((LinkedHashMap) ((ArrayList) keywordResponse.get("documents")).get(0)).get("category_group_name").toString();

            Map addressResponse = useKakaoLocalApi(false, dto.getAddress());
            Double latitude = Double.parseDouble((String) ((LinkedHashMap) ((LinkedHashMap) ((ArrayList) addressResponse.get("documents")).get(0)).get("address")).get("y"));
            Double longitude = Double.parseDouble((String) ((LinkedHashMap) ((LinkedHashMap) ((ArrayList) addressResponse.get("documents")).get(0)).get("address")).get("x"));

            System.out.println("latitude: " + latitude + ", longitude: " + longitude);

            // 새로운 거래 내역 등록
//            AccountHistory accountHistory = AccountHistory.toAccountHistory(account, dto.getStoreName(), dto.isType(), dto.getMoney(), )
        }

//        accountService.

        return null;
    }

    private Map useKakaoLocalApi(boolean flag, String value) {

//        WebClient webClient = WebClient.builder()
//                .baseUrl("https://dapi.kakao.com/v2/local/search")
//                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
//                .defaultHeader("Authorization", "KakaoAK db388e6b11004c2105b5ce40ac21b2a0")
//                .build();
//
//        if(flag) {
//            return webClient.get()
//                    .uri(uriBuilder -> uriBuilder
//                            .path("/keyword.json")
//                            .queryParam("query", value)
//                            .queryParam("size", 1)
//                            .build())
//                    .retrieve()
////                    .bodyToMono(String.class)
//                    .bodyToMono(JSONObject.class)
//                    .block();
//        }
////        else {
////            return webClient.get()
////                    .uri(uriBuilder -> uriBuilder
////                            .path("/address.json")
////                            .queryParam("query", value)
////                            .queryParam("size", 1)
////                            .build())
////                    .retrieve()
////                    .bodyToMono(String.class)
////                    .block();
////        }
//        return null;

        RestTemplate restTemplate = new RestTemplate();

        final HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK db388e6b11004c2105b5ce40ac21b2a0");

        // 헤더를 넣은 HttpEntity 생성
        final HttpEntity<String> entity = new HttpEntity<String>(headers);

        if(flag) {
            URI targetUrl = UriComponentsBuilder
                    .fromUriString("https://dapi.kakao.com/v2/local/search/keyword.json") //기본 url
                    .queryParam("query", value) //인자
                    .queryParam("size", 1)
                    .build()
                    .encode(StandardCharsets.UTF_8) //인코딩
                    .toUri();

            ResponseEntity<Map> result = restTemplate.exchange(targetUrl, HttpMethod.GET, entity, Map.class);
            return result.getBody(); //내용 반환
        }
        else {
            URI targetUrl = UriComponentsBuilder
                    .fromUriString("https://dapi.kakao.com/v2/local/search/address.json") //기본 url
                    .queryParam("query", value) //인자
                    .queryParam("size", 1)
                    .build()
                    .encode(StandardCharsets.UTF_8) //인코딩
                    .toUri();

            ResponseEntity<Map> result = restTemplate.exchange(targetUrl, HttpMethod.GET, entity, Map.class);
            return result.getBody(); //내용 반환
        }
    }
}
