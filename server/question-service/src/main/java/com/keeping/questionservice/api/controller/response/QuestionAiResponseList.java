package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class QuestionAiResponseList {
    List<QuestionAiResponse> questionAiResponses;

    @Builder
    public QuestionAiResponseList(List<QuestionAiResponse> questionAiResponses) {
        this.questionAiResponses = questionAiResponses;
    }
}
