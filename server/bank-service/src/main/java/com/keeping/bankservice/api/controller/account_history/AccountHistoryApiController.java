package com.keeping.bankservice.api.controller.account_history;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.account_history.request.AddAccountHistoryRequest;
import com.keeping.bankservice.api.controller.account_history.response.ShowAccountHistoryResponse;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/api/account-history")
public class AccountHistoryApiController {

    private final AccountHistoryService accountHistoryService;

    // TODO: service단에 memberKey 넘겨서 검증하는 과정 필요
    @PostMapping("/{member-key}")
    public ApiResponse<Void> addAccountHistory(@PathVariable("member-key") String memberKey, @RequestBody AddAccountHistoryRequest request) {
        log.debug("AddAccountHistory={}", request);

        AddAccountHistoryDto dto = AddAccountHistoryDto.toDto(request);

//        try {
//            Long accountHistoryId = accountHistoryService.addAccountHistory(dto);
//        }

        return null;
    }

    @GetMapping("/{member-key}")
    public ApiResponse<Map<String, ShowAccountHistoryResponse>> showAccountHistory(@PathVariable("member-key") String memberKey) {
        log.debug("ShowAccountHistory");

//        try {
//            Map<String, ShowAccountHistoryResponse> response = accountHistoryService.showAccountHistory(memberKey);
//        }


        return null;
    }

    @GetMapping("/{member-key}/{account-number}/{date}")
    public ApiResponse<Map<String, List<ShowAccountHistoryResponse>>> showAccountDailyHistory(@PathVariable("member-key") String memberKey, @PathVariable("account-number") String accountNumber, @PathVariable("date") String date) {
        log.debug("ShowAccountDailyHistory");

        try {
            Map<String, List<ShowAccountHistoryResponse>> response = accountHistoryService.showAccountDailyHistory(memberKey, accountNumber, date);
            return ApiResponse.ok(response);
        }
        catch(Exception e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "거래 내역을 불러오는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }
}
