package com.keeping.bankservice.api.controller.account_history;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.account_history.response.ShowChildHistoryResponse;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/server/account-history")
public class AccountHistoryServerApiController {

    private final AccountHistoryService accountHistoryService;

    @GetMapping("/test")
    ApiResponse<String> testBank() {
        log.debug("[Bank Test]");

        return ApiResponse.ok("테스트 완료");
    }

    @GetMapping("/question")
    public ApiResponse<List<ShowChildHistoryResponse>> showChildHistory() {
        log.debug("ShowChildHistory");

        try {
            List<ShowChildHistoryResponse> response =  accountHistoryService.showChildHistory();
            return ApiResponse.ok(response);
        }
        catch (Exception e) {
            log.debug("에러 발생 : {}", e.toString());
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "자녀 거래 내역을 불러오는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }
}
