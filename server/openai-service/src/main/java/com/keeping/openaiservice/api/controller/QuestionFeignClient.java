package com.keeping.openaiservice.api.controller;

import com.keeping.openaiservice.api.ApiResponse;
import com.keeping.openaiservice.api.controller.response.QuestionAiResponseList;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "question-service")
public interface QuestionFeignClient {

    @PostMapping("/question-service/api/save-api-question")
    ApiResponse<Void> addAiQuestion(@RequestBody QuestionAiResponseList requestList);

}
