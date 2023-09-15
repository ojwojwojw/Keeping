package com.keeping.openaiservice.controller;

import com.keeping.openaiservice.controller.request.GPTCompletionChatRequest;
import com.keeping.openaiservice.controller.response.CompletionChatResponse;
import com.keeping.openaiservice.service.GptService;
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

    @PostMapping("/gpt")
    public CompletionChatResponse completionChat(final @RequestBody GPTCompletionChatRequest request) {
        log.info("request={}", request);
        return gptService.completionChat(request);
    }
}
