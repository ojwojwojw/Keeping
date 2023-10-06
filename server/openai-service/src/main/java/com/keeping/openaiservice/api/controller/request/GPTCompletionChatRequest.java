package com.keeping.openaiservice.api.controller.request;

import com.theokanning.openai.completion.chat.ChatCompletionRequest;
import com.theokanning.openai.completion.chat.ChatMessage;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class GPTCompletionChatRequest {
    
    private String role;
    
    private String message;

    public static ChatCompletionRequest of(GPTCompletionChatRequest request) {
        return ChatCompletionRequest.builder()
                .model("gpt-3.5-turbo")
                .messages(convertChatMessage(request))
                .temperature(0.8)
                .maxTokens(500)
                .build();
    }

    private static List<ChatMessage> convertChatMessage(GPTCompletionChatRequest request) {
        return List.of(new ChatMessage(request.getRole(), request.getMessage()));
    }
}
