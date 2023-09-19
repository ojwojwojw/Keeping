package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

@Data
public class QuestionResponse {

    private String content;
    private String type;
    private String parentAnswer;
    private String childAnswer;

    @Builder
    private QuestionResponse(String content, String type, String parentAnswer, String childAnswer) {
        this.content = content;
        this.type = type;
        this.parentAnswer = parentAnswer;
        this.childAnswer = childAnswer;
    }
}
