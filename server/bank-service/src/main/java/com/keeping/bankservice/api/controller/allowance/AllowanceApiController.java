package com.keeping.bankservice.api.controller.allowance;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.allowance.request.AddAllowanceRequest;
import com.keeping.bankservice.api.controller.allowance.request.ApproveAllowanceRequest;
import com.keeping.bankservice.api.service.allowance.AllowanceService;
import com.keeping.bankservice.api.service.allowance.dto.AddAllowanceDto;
import com.keeping.bankservice.api.service.allowance.dto.ApproveAllowanceDto;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/api/{member-key}/allowance")
public class AllowanceApiController {

    private final AllowanceService allowanceService;

    @PostMapping()
    public ApiResponse<Void> addAllowance(@PathVariable("member-key") String memberKey, @RequestBody AddAllowanceRequest request) {
        log.debug("AddAllowance={}", request);

        AddAllowanceDto dto = AddAllowanceDto.toDto(request);

        try {
            allowanceService.addAllowance(memberKey, dto);
        } catch (Exception e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "현재 서비스 이용이 불가능합니다. 잠시 후 다시 시도해 주세요.", null);
        }

        return ApiResponse.ok(null);
    }

    @PostMapping("/approve")
    public ApiResponse<Void> approveAllowance(@PathVariable("member-key") String memberKey, @RequestBody ApproveAllowanceRequest request) {
        log.debug("ApproveAllowance={}", request);

        ApproveAllowanceDto dto = ApproveAllowanceDto.toDto(request);

        try {
            allowanceService.approveAllowance(memberKey, dto);
        } catch (NotFoundException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        }

        return ApiResponse.ok(null);
    }
}
