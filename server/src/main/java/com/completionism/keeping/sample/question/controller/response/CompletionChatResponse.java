package com.completionism.keeping.sample.question.controller.response;

import com.theokanning.openai.completion.CompletionChoice;
import com.theokanning.openai.completion.chat.ChatCompletionChoice;
import com.theokanning.openai.completion.chat.ChatCompletionResult;
import com.theokanning.openai.completion.chat.ChatMessage;
import lombok.*;

import java.util.List;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CompletionChatResponse {
    
    private String id;
    
    private String object;
    
    private Long created;
    
    private String model;
    
    private List<Message> messages;
    
    private Usage usage;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Message {
        
        private String role;
        
        private String Message;

        public static Message of(ChatMessage chatMessage) {
            return new Message(
                    chatMessage.getRole(),
                    chatMessage.getContent()
            );
        }
    }

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Usage {
        
        private Long promptTokens;
        
        private Long completionTokens;
        
        private Long totalTokens;

        public static Usage of(com.theokanning.openai.Usage usage) {
            return new Usage(
                    usage.getPromptTokens(),
                    usage.getCompletionTokens(),
                    usage.getTotalTokens()
            );
        }
    }

    public static List<CompletionChatResponse.Message> toResponseListBy(List<ChatCompletionChoice> choices) {
        return choices.stream()
                .map(completionChoice -> Message.of(completionChoice.getMessage()))
                .collect(Collectors.toList());
    }

    public static CompletionChatResponse of(ChatCompletionResult result) {
        return new CompletionChatResponse(
                result.getId(),
                result.getObject(),
                result.getCreated(),
                result.getModel(),
                toResponseListBy(result.getChoices()),
                Usage.of(result.getUsage())
        );
    }
    
}
