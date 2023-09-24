package com.keeping.openaiservice.api.controller.response;

import lombok.Builder;

import java.util.List;

public class QuestionAiResponseList {

    List<QuestionAiResponse> questionAiResponses;

    @Builder
    public QuestionAiResponseList(List<QuestionAiResponse> questionAiResponses) {
        this.questionAiResponses = questionAiResponses;
    }
}
