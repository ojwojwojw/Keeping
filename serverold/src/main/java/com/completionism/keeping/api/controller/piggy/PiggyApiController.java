package com.completionism.keeping.api.controller.piggy;

import com.completionism.keeping.api.ApiResponse;
import com.completionism.keeping.api.controller.piggy.request.AddPiggyRequest;
import com.completionism.keeping.api.controller.piggy.response.ShowPiggyResponse;
import com.completionism.keeping.api.service.piggy.PiggyService;
import com.completionism.keeping.api.service.piggy.dto.AddPiggyDto;
import com.completionism.keeping.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/piggy")
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

    @GetMapping("/{member-key}")
    public ApiResponse<List<ShowPiggyResponse>> showPiggy(@PathVariable("member-key") String memberKey) {
        log.debug("showPiggy");

        try {
            List<ShowPiggyResponse> response = piggyService.showPiggy(memberKey);
            return ApiResponse.ok(response);
        } catch (IOException e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "저금통 정보를 불러오는 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }
}
