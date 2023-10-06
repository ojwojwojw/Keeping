package com.keeping.bankservice.api.controller.online;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.online.request.AddOnlineRequest;
import com.keeping.bankservice.api.controller.online.request.ApproveOnlineRequest;
import com.keeping.bankservice.api.controller.online.response.ShowOnlineResponse;
import com.keeping.bankservice.api.service.online.OnlineService;
import com.keeping.bankservice.api.service.online.dto.AddOnlineDto;
import com.keeping.bankservice.api.service.online.dto.ApproveOnlineDto;
import com.keeping.bankservice.global.common.Approve;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.net.URISyntaxException;
import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/api/{member-key}/online")
public class OnlineApiController {

    private final OnlineService onlineService;

    @PostMapping
    public ApiResponse<Void> addOnline(@PathVariable("member-key") String memberKey, @RequestBody AddOnlineRequest request) {
        log.debug("AddOnline={}", request);

        AddOnlineDto dto = AddOnlineDto.toDto(request);

        try {
            onlineService.addOnline(memberKey, dto);
        } catch (Exception e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "현재 서비스 이용이 불가능합니다. 잠시 후 다시 시도해 주세요.", null);
        }

        return ApiResponse.ok(null);
    }

    @PostMapping("/approve")
    public ApiResponse<Void> approveOnline(@PathVariable("member-key") String memberKey, @RequestBody ApproveOnlineRequest request) {
        log.debug("ApproveAllowance={}", request);

        ApproveOnlineDto dto = ApproveOnlineDto.toDto(request);

        try {
            onlineService.approveOnline(memberKey, dto);
        } catch (NotFoundException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        } catch (URISyntaxException e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "현재 서비스 이용이 불가능합니다. 잠시 후 다시 시도해 주세요.", null);
        }

        return ApiResponse.ok(null);
    }

    @GetMapping("/{target-key}")
    public ApiResponse<List<ShowOnlineResponse>> showOnline(@PathVariable("member-key") String memberKey, @PathVariable("target-key") String targetKey) {
        log.debug("ShowOnline={}", targetKey);

        try {
            List<ShowOnlineResponse> response = onlineService.showOnline(memberKey, targetKey);
            return ApiResponse.ok(response);
        } catch (Exception e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "현재 서비스 이용이 불가능합니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }

    @GetMapping("/{target-key}/{approve}")
    public ApiResponse<List<ShowOnlineResponse>> showTypeOnline(@PathVariable("member-key") String memberKey, @PathVariable("target-key") String targetKey, @PathVariable("approve") Approve approve) {
        log.debug("ShowTypeOnline={}, {}", targetKey, approve);

        try {
            List<ShowOnlineResponse> response = onlineService.showTypeOnline(memberKey, targetKey, approve);
            return ApiResponse.ok(response);
        } catch (Exception e) {
            return ApiResponse.of(1, HttpStatus.SERVICE_UNAVAILABLE, "현재 서비스 이용이 불가능합니다. 잠시 후 다시 시도해 주세요.", null);
        }
    }

    @GetMapping("/{target-key}/detail/{online-id}")
    public ApiResponse<ShowOnlineResponse> showDetailOnline(@PathVariable("member-key") String memberKey, @PathVariable("target-key") String targetKey, @PathVariable("online-id") Long onlineId) {
        log.debug("ShowDetailOnline={}", onlineId);

        try {
            ShowOnlineResponse response = onlineService.showDetailOnline(memberKey, targetKey, onlineId);
            return ApiResponse.ok(response);
        } catch (NotFoundException | NoAuthorizationException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        }
    }

}
