package com.keeping.notiservice.api.controller;

import com.keeping.notiservice.api.ApiResponse;
import com.keeping.notiservice.api.controller.request.QuestionNotiRequestList;
import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.api.service.NotiService;
import com.keeping.notiservice.api.service.dto.FCMNotificationDto;
import com.keeping.notiservice.api.service.FCMNotificationService;
import com.keeping.notiservice.api.service.dto.SendNotiDto;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/noti-service/api")
@RequiredArgsConstructor
public class NotiApiController {
    
    private final FCMNotificationService fcmNotificationService;
    private final NotiService notiService;

    @PostMapping("/question-send")
    public ApiResponse<Void> sendQuestionNoti(
            @RequestBody QuestionNotiRequestList requestList
    ) {
        notiService.sendNotis(requestList);
        return ApiResponse.ok(null);
    }
    
    @GetMapping("/{member_key}")
    public ApiResponse<List<NotiResponse>> showNoti(
            @Valid @PathVariable(name = "member_key") String memberKey
    ) {
        List<NotiResponse> notiResponses = notiService.showNoti(memberKey);
        return ApiResponse.ok(notiResponses);
    }

    @PostMapping
    public String sendNotification(@RequestBody FCMNotificationDto request) {
        return fcmNotificationService.sendNotification(request);
    }
    
}
