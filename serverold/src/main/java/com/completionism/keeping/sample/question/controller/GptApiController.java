package com.completionism.keeping.sample.question.controller;

import com.completionism.keeping.sample.question.controller.request.GPTCompletionChatRequest;
import com.completionism.keeping.sample.question.controller.response.CompletionChatResponse;
import com.completionism.keeping.sample.question.service.GptService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

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
