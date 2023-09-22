package com.keeping.bankservice.api.controller.account;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.account.request.AddAccountRequest;
import com.keeping.bankservice.api.controller.account.request.AuthPhoneRequest;
import com.keeping.bankservice.api.controller.account.request.CheckPhoneRequest;
import com.keeping.bankservice.api.controller.account.request.DepositAllowanceRequest;
import com.keeping.bankservice.api.controller.account_history.response.ShowAccountHistoryResponse;
import com.keeping.bankservice.api.service.account.AccountService;
import com.keeping.bankservice.api.service.account.dto.AddAccountDto;
import com.keeping.bankservice.api.service.account.dto.AuthPhoneDto;
import com.keeping.bankservice.api.service.account.dto.CheckPhoneDto;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/api/account")
public class AccountApiController {

    private final AccountService accountService;

    @PostMapping("/{member-key}")
    public ApiResponse<Void> addAccount(@PathVariable("member-key") String memberKey, @RequestBody AddAccountRequest request) {
        log.debug("AddAccountRequest={}", request);

        AddAccountDto dto = AddAccountDto.toDto(request);

        try {
            Long accountId = accountService.addAccount(memberKey, dto);
            return ApiResponse.ok(null);
        }
        catch(JsonProcessingException e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "현재 서비스 이용이 불가능합니다. 잠시 후 다시 시도해 주세요.", null);
        }
        catch(NoAuthorizationException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        }
    }

    @PostMapping("/phone-check/{member-key}")
    public ApiResponse<Void> checkPhone(@PathVariable("member-key") String memberKey, @RequestBody CheckPhoneRequest request) {
        log.debug("CheckPhoneRequest={}", request);

        CheckPhoneDto dto = CheckPhoneDto.toDto(request);

        try {
            accountService.checkPhone(memberKey, dto);
        } catch (UnsupportedEncodingException | NoSuchAlgorithmException | URISyntaxException | InvalidKeyException | JsonProcessingException e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "인증 번호를 전송하는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
        return ApiResponse.ok(null);
    }

    @PostMapping("/phone-auth/{member-key}")
    public ApiResponse<Void> authPhone(@PathVariable("member-key") String memberKey, @RequestBody AuthPhoneRequest request) {
        log.debug("AuthPhoneRequest={}", request);

        AuthPhoneDto dto = AuthPhoneDto.toDto(request);

        try {
            accountService.authPhone(memberKey, dto);
            return ApiResponse.ok(null);
        }
        catch(NoAuthorizationException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        }
        catch(JsonProcessingException e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "인증 번호를 전송하는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }

    @DeleteMapping("/{member-key}/{account-number}")
    public ApiResponse<Void> removeAccount(@PathVariable("member-key") String memberKey, @PathVariable("account-number") String accountNumber) {
        log.debug("RemoveAccount={}, {}", memberKey, accountNumber);

        return null;
    }

    @PostMapping("/allowance/{member-key}")
    public ApiResponse<Void> depositAllowance(@RequestBody DepositAllowanceRequest request) {
        log.debug("DepositAllowanceRequest={}", request);

        return null;
    }

    @PostMapping("/allowance/sub/{member-key}")
    public ApiResponse<Void> depositAllowanceSub(@RequestBody DepositAllowanceRequest request) {
        log.debug("DepositAllowanceSubRequest={}", request);

        return null;
    }
}
