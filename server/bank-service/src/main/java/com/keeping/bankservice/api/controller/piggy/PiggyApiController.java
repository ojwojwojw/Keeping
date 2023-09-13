package com.keeping.bankservice.api.controller.piggy;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.piggy.request.AddPiggyRequest;
import com.keeping.bankservice.api.service.piggy.PiggyService;
import com.keeping.bankservice.api.service.piggy.dto.AddPiggyDto;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/piggy")
public class PiggyApiController {

    private final PiggyService piggyService;

    @PostMapping("/{member-key}")
    public ApiResponse<Void> addPiggy(@PathVariable("member-key") String memberKey, @RequestParam("content") String content, @RequestParam("goalMoney") int goalMoney, @RequestParam("authPassword") String authPassword, @RequestParam("uploadImage") MultipartFile uploadImage) {
        AddPiggyRequest request = AddPiggyRequest.toRequest(content, goalMoney, authPassword, uploadImage);
        log.debug("AddPiggyRequest={}", request);

        AddPiggyDto dto = AddPiggyDto.toDto(request);

        try {
            Long piggyId = piggyService.addPiggy(memberKey, dto);
        }
        catch(IOException e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "저금통 개설 과정 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
        catch(NotFoundException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        }

        return ApiResponse.ok(null);
    }
}
