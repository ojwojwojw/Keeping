package com.keeping.notiservice.api.controller;

import com.keeping.notiservice.api.ApiResponse;
import com.keeping.notiservice.api.controller.request.QuestionNotiRequestList;
import com.keeping.notiservice.api.service.NotiService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/noti-service")
@RequiredArgsConstructor
public class NotiNoAuthApiController {
    
    private final NotiService notiService;

    @PostMapping("/question-send")
    public ApiResponse<Void> sendQuestionNoti(
            @RequestBody QuestionNotiRequestList requestList
    ) {
        notiService.sendNotis(requestList);
        return ApiResponse.ok(null);
    }

}
