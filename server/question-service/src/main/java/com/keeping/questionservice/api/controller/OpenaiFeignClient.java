package com.keeping.questionservice.api.controller;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.response.QuestionAiResponseList;
import com.keeping.questionservice.global.config.CustomRetryer;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "openai-service", configuration = CustomRetryer.class)
public interface OpenaiFeignClient {
    
    @GetMapping("/openai-service/api/transaction-question")
    ApiResponse<QuestionAiResponseList> createQuestion();

}
