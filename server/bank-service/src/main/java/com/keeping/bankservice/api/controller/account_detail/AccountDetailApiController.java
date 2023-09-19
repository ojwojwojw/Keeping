package com.keeping.bankservice.api.controller.account_detail;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.account_detail.request.AddAccountDetailRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/account-detail")
public class AccountDetailApiController {

    @PostMapping("/{member-key}")
    public ApiResponse<Void> addAccountDetail(@RequestBody AddAccountDetailRequest request) {
        log.debug("AddAccountDetailRequest={}", request);

        return null;
    }

}
