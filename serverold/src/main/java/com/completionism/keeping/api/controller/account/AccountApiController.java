package com.completionism.keeping.api.controller.account;

import com.completionism.keeping.api.ApiResponse;
import com.completionism.keeping.api.controller.account.request.AddAccountRequest;
import com.completionism.keeping.api.service.account.AccountService;
import com.completionism.keeping.api.service.account.dto.AddAccountDto;
import com.completionism.keeping.global.utils.SecurityUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/account")
public class AccountApiController {

    private final AccountService accountService;

    @PostMapping
    public ApiResponse<Void> addAccount(@RequestBody AddAccountRequest request) {
        log.debug("AddAccountRequest={}", request);

        String loginId = SecurityUtils.getCurrentLoginId();
        AddAccountDto dto = AddAccountDto.toDto(request);

        try {
            Long accountId = accountService.addAccount(loginId, dto);
            return ApiResponse.ok(null);
        }
        catch(JsonProcessingException e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "현재 서비스 이용이 불가능합니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }
}
