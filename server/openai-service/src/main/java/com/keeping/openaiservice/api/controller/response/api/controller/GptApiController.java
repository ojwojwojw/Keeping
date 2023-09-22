package com.keeping.openaiservice.api.controller.response.api.controller;

import com.keeping.openaiservice.api.controller.response.api.controller.request.TransactionRequestList;
import com.keeping.openaiservice.api.controller.response.api.service.GptService;
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
    public  completionChat(final @RequestBody TransactionRequestList request) {
        log.info("request={}", request);
        return gptService.createQuestion(request);
    }
}
