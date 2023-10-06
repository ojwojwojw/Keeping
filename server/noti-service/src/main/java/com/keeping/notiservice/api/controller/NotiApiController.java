package com.keeping.notiservice.api.controller;

import com.keeping.notiservice.api.ApiResponse;
import com.keeping.notiservice.api.controller.request.QuestionNotiRequestList;
import com.keeping.notiservice.api.controller.request.SendNotiRequest;
import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.api.service.NotiService;
import com.keeping.notiservice.api.service.dto.FCMNotificationDto;
import com.keeping.notiservice.api.service.FCMNotificationService;
import com.keeping.notiservice.api.service.dto.SendNotiDto;
import com.keeping.notiservice.domain.noti.Type;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/noti-service/api/{member_key}")
@RequiredArgsConstructor
public class NotiApiController {
    
    private final FCMNotificationService fcmNotificationService;
    private final NotiService notiService;

    @PostMapping
    public ApiResponse<Long> sendNoti(
            @Valid @PathVariable(name = "member_key") String memberKey,
            @RequestBody SendNotiRequest request
    ) {
        Long notiId = notiService.sendNoti(SendNotiDto.toDto(request));
        return ApiResponse.ok(notiId);
    }
    
    @GetMapping
    public ApiResponse<List<NotiResponse>> showNoti(
            @Valid @PathVariable(name = "member_key") String memberKey
    ) {
        List<NotiResponse> notiResponses = notiService.showNoti(memberKey);
        return ApiResponse.ok(notiResponses);
    }

    @GetMapping("/{type}")
    public ApiResponse<List<NotiResponse>> showNotiByType(
            @PathVariable(name = "member_key") String memberKey,
            @PathVariable(name = "type") String  type
            ) {
        List<NotiResponse> notiResponses = notiService.showNotiByType(memberKey, type);
        return ApiResponse.ok(notiResponses);
    }
    
}
