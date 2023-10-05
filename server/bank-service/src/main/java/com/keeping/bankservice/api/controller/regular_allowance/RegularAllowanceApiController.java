package com.keeping.bankservice.api.controller.regular_allowance;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.regular_allowance.request.MakeRegularAllowanceRequest;
import com.keeping.bankservice.api.service.regular_allowance.RegularAllowanceService;
import com.keeping.bankservice.api.service.regular_allowance.dto.MakeRegularAllowanceDto;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/api/{member-key}/regular-allowance")
public class RegularAllowanceApiController {

    private final RegularAllowanceService regularAllowanceService;

    @PostMapping
    public ApiResponse<Void> makeRegularAllowance(@PathVariable("member-key") String memberKey, @RequestBody MakeRegularAllowanceRequest request) {
        log.debug("MakeRegularAllowanceRequest={}", request);

        MakeRegularAllowanceDto dto = MakeRegularAllowanceDto.toDto(request);

        try {
            regularAllowanceService.makeRegularAllowance(memberKey, dto);
            return ApiResponse.ok(null);
        }
        catch (NotFoundException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        }
    }
}
