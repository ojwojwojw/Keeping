package com.keeping.openaiservice.service.impl;

import com.keeping.openaiservice.controller.request.GPTCompletionChatRequest;
import com.keeping.openaiservice.controller.response.CompletionChatResponse;
import com.keeping.openaiservice.service.GptService;
import com.theokanning.openai.completion.chat.ChatCompletionResult;
import com.theokanning.openai.service.OpenAiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class GptServiceImpl implements GptService {
    
    private final OpenAiService openAiService;

    @Override
    public CompletionChatResponse completionChat(GPTCompletionChatRequest request) {
        ChatCompletionResult chatCompletion = openAiService.createChatCompletion(
                GPTCompletionChatRequest.of(request));

        CompletionChatResponse response = CompletionChatResponse.of(chatCompletion);

        List<String> messages = response.getMessages().stream()
                .map(CompletionChatResponse.Message::getMessage)
                .collect(Collectors.toList());
        
        log.info("messages={}", messages);
        return response;
    }
    
}
