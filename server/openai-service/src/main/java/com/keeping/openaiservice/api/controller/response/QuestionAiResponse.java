package com.keeping.openaiservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class QuestionAiResponse {
    
    private String answer;

    @Builder
    public QuestionAiResponse(String answer) {
        this.answer = answer;
    }
}
