package com.keeping.questionservice.api.controller;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.response.QuestionAiResponseList;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "openai-service")
public interface OpenaiFeignClient {
    
    @GetMapping("/openai-service/transaction-question")
    ApiResponse<QuestionAiResponseList> createQuestion();
}
