package com.completionism.keeping.sample.question.controller.request;

import com.theokanning.openai.completion.CompletionRequest;
import com.theokanning.openai.completion.chat.ChatCompletionRequest;
import com.theokanning.openai.completion.chat.ChatMessage;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Value;

import java.util.List;

@Data
public class GPTCompletionChatRequest {
    
    private String role;
    
    private String message;
    
    private Integer maxTokens;

    public static ChatCompletionRequest of(GPTCompletionChatRequest request) {
        return ChatCompletionRequest.builder()
                .model("gpt-3.5-turbo")
                .messages(convertChatMessage(request))
                .maxTokens(request.getMaxTokens())
                .build();
    }

    private static List<ChatMessage> convertChatMessage(GPTCompletionChatRequest request) {
        return List.of(new ChatMessage(request.getRole(), request.getMessage()));
    }
}
