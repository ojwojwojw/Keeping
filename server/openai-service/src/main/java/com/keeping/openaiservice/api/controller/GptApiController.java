package com.keeping.openaiservice.api.controller;

import com.keeping.openaiservice.api.ApiResponse;
import com.keeping.openaiservice.api.controller.request.TransactionRequestList;
import com.keeping.openaiservice.api.controller.response.QuestionAiResponse;
import com.keeping.openaiservice.api.service.GptService;
import com.keeping.openaiservice.api.controller.request.GPTCompletionChatRequest;
import com.keeping.openaiservice.api.controller.response.CompletionChatResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api")
public class GptApiController {
    
    private final GptService gptService;

    @PostMapping("/transaction-question")
    public ApiResponse<QuestionAiResponse> completionChat(final @RequestBody TransactionRequestList request) {
        log.info("request={}", request);
        return ApiResponse.ok(gptService.createQuestion(request));
    }
}
