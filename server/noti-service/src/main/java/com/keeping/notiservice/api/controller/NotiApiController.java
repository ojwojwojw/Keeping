package com.keeping.notiservice.api.controller;

import com.keeping.notiservice.api.controller.request.SendNotiRequest;
import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.api.controller.response.NotiResponseList;
import com.keeping.notiservice.api.service.NotiService;
import com.keeping.notiservice.api.service.dto.FCMNotificationDto;
import com.keeping.notiservice.api.service.FCMNotificationService;
import com.keeping.notiservice.api.service.dto.SendNotiDto;
import com.keeping.notiservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class NotiApiController {

    private final NotiService notiService;

    @PostMapping("/send")
    public ApiResponse<Long> sendNotification(@RequestBody SendNotiRequest request) {
        return ApiResponse.ok(notiService.sendNoti(SendNotiDto.toDto(request)));
    }

    @GetMapping("/{member_key}")
    public ApiResponse<NotiResponseList> showNoti(
            @PathVariable(name = "member_key") String memberKey
    ) {
        List<NotiResponse> notiResponses = notiService.showNoti(memberKey);

        return ApiResponse.ok(NotiResponseList.builder()
                .notiResponseList(notiResponses)
                .build());
    }

    @GetMapping("/{member_key}/{noti_id}")
    public ApiResponse<NotiResponse> showDetailNoti(
            @PathVariable(name = "member_key") String memberKey,
            @PathVariable(name = "noti_id") Long notiId
    ) {
        try {
            NotiResponse notiResponse = notiService.showDetailNoti(memberKey, notiId);
            return ApiResponse.ok(notiResponse);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage(), null);
        }
    }
    
}
