package com.keeping.questionservice.api.controller;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.request.QuestionNotiRequestList;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "/noti-service/api")
public interface NotiFeignClient {
    
    @PostMapping("/send")
    ApiResponse<Void> sendQuestionNoti(@RequestBody QuestionNotiRequestList request);
    
}
