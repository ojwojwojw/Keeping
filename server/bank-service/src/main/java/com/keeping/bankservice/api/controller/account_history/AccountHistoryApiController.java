package com.keeping.bankservice.api.controller.account_history;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.account_history.request.AddAccountHistoryRequest;
import com.keeping.bankservice.api.controller.account_history.response.ShowAccountHistoryResponse;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import com.keeping.bankservice.global.exception.InvalidRequestException;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/api/{member-key}/account-history")
public class AccountHistoryApiController {

    private final AccountHistoryService accountHistoryService;

    @PostMapping
    public ApiResponse<Void> addAccountHistory(@PathVariable("member-key") String memberKey, @RequestBody AddAccountHistoryRequest request) {
        log.debug("AddAccountHistory={}", request);

        AddAccountHistoryDto dto = AddAccountHistoryDto.toDto(request);

        try {
            Long accountHistoryId = accountHistoryService.addAccountHistory(memberKey, dto);
        } catch (URISyntaxException e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "거래 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        } catch (NoAuthorizationException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        } catch (InvalidRequestException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        }

        return null;
    }

    @GetMapping("/{account-number}")
    public ApiResponse<Map<String, List<ShowAccountHistoryResponse>>> showAccountHistory(@PathVariable("member-key") String memberKey, @PathVariable("account-number") String accountNumber) {
        log.debug("ShowAccountHistory");

        try {
            Map<String, List<ShowAccountHistoryResponse>> response = accountHistoryService.showAccountHistory(memberKey, accountNumber);
            return ApiResponse.ok(response);
        }
        catch(Exception e) {
            log.debug("에러 발생 : {}", e.toString());
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "거래 내역을 불러오는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }

    @GetMapping("/{account-number}/{date}")
    public ApiResponse<Map<String, List<ShowAccountHistoryResponse>>> showAccountDailyHistory(@PathVariable("member-key") String memberKey, @PathVariable("account-number") String accountNumber, @PathVariable("date") String date) {
        log.debug("ShowAccountDailyHistory");

        try {
            Map<String, List<ShowAccountHistoryResponse>> response = accountHistoryService.showAccountDailyHistory(memberKey, accountNumber, date);
            return ApiResponse.ok(response);
        }
        catch(Exception e) {
            log.debug("에러 발생 : {}", e.toString());
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "거래 내역을 불러오는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }

    @GetMapping("/expense/{date}")
    public ApiResponse<Long> countMonthExpense(@PathVariable("member-key") String memberKey, @PathVariable("date") String date) {
        log.debug("CountMonthExpense");

        try {
            Long totalExpense = accountHistoryService.countMonthExpense(memberKey, date);
            return ApiResponse.ok(totalExpense);
        }
        catch (Exception e) {
            log.debug("에러 발생 : {}", e.toString());
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "월별 지출 총합을 계산하는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }
}
