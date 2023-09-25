package com.keeping.openaiservice.api.controller;

import com.keeping.openaiservice.api.ApiResponse;
import com.keeping.openaiservice.api.controller.request.TransactionRequestList;
import com.keeping.openaiservice.api.controller.response.QuestionAiResponse;
import com.keeping.openaiservice.api.controller.response.QuestionAiResponseList;
import com.keeping.openaiservice.api.service.GptService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api")
public class GptApiController {
    
    private final GptService gptService;

    @GetMapping("/transaction-question")
    public ApiResponse<QuestionAiResponseList> createQuestion() {
        return ApiResponse.ok(gptService.createQuestion());
    }
}
