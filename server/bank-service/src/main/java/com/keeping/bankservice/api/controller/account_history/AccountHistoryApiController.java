package com.keeping.bankservice.api.controller.account_history;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.account_history.response.ShowAccountHistoryResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/account-history")
public class AccountHistoryApiController {

    @GetMapping("/account/detail/{member-key}")
    public ApiResponse<ShowAccountHistoryResponse> showAccountHistory(@PathVariable("member-key") String memberKey) {
        log.debug("ShowAccountHistory");

        return null;
    }
}
