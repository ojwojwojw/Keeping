package com.keeping.bankservice.api.controller.piggy;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.piggy.request.AddPiggyRequest;
import com.keeping.bankservice.api.controller.piggy_history.response.ShowPiggyHistoryResponse;
import com.keeping.bankservice.api.controller.piggy.response.ShowPiggyResponse;
import com.keeping.bankservice.api.controller.piggy.request.SavingPiggyRequest;
import com.keeping.bankservice.api.service.account.dto.SavingPiggyDto;
import com.keeping.bankservice.api.service.piggy.PiggyService;
import com.keeping.bankservice.api.service.piggy.dto.AddPiggyDto;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/api/{member-key}/piggy")
public class PiggyApiController {

    private final PiggyService piggyService;

    @PostMapping
    public ApiResponse<Void> addPiggy(@PathVariable("member-key") String memberKey, @RequestParam("content") String content, @RequestParam("goalMoney") int goalMoney, @RequestParam("uploadImage") MultipartFile uploadImage) {
        AddPiggyRequest request = AddPiggyRequest.toRequest(content, goalMoney, uploadImage);
        log.debug("AddPiggyRequest={}", request);

        AddPiggyDto dto = AddPiggyDto.toDto(request);

        try {
            Long piggyId = piggyService.addPiggy(memberKey, dto);
        } catch (IOException e) {
            log.debug("예외 발생 : {}", e.toString());
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "저금통 개설 과정 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        } catch (NotFoundException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        }

        return ApiResponse.ok(null);
    }

    @GetMapping
    public ApiResponse<List<ShowPiggyResponse>> showPiggy(@PathVariable("member-key") String memberKey) {
        log.debug("showPiggy");

        try {
            List<ShowPiggyResponse> response = piggyService.showPiggy(memberKey);
            return ApiResponse.ok(response);
        } catch (IOException e) {
            log.debug("예외 발생 : {}", e.toString());
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "저금통 정보를 불러오는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }

    @PostMapping("/saving")
    public ApiResponse<Void> savingPiggy(@PathVariable("member-key") String memberKey, @RequestBody SavingPiggyRequest request) {
        log.debug("SavingPiggyRequest={}", request);

        SavingPiggyDto dto = SavingPiggyDto.toDto(request);

        try {
            piggyService.savingPiggy(memberKey, dto);
        } catch (NotFoundException | NoAuthorizationException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        } catch (URISyntaxException e) {
            log.debug("예외 발생 : {}", e.toString());
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "저금통에 저금하는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
        return ApiResponse.ok(null);
    }

    @DeleteMapping("/{account-number}")
    public ApiResponse<Void> removePiggy(@PathVariable("member-key") String memberKey, @PathVariable("account-number") String accountNumber) {
        log.debug("RemovePiggy={}, {}", memberKey, accountNumber);

        return null;
    }

    @DeleteMapping("/approve/{account-number}")
    public ApiResponse<Void> approveRemovePiggy(@PathVariable("member-key") String memberKey, @PathVariable("account-number") String accountNumber) {
        log.debug("ApproveRemovePiggy={}, {}", memberKey, accountNumber);

        return null;
    }

    @GetMapping("/{account-number}")
    public ApiResponse<ShowPiggyHistoryResponse> showPiggyHistory(@PathVariable("member-key") String memberKey, @PathVariable("account-number") String accountNumber) {
        log.debug("ShowPiggyHistory={}, {}", memberKey, accountNumber);

        return null;
    }
}
