package com.keeping.questionservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Data
public class AddAnswerRequest {

    @NotBlank
    private Long questionId;
    @NotBlank
    private String answer;
    @NotBlank
    private String type;

    @Builder
    private AddAnswerRequest(Long questionId, String answer, String type) {
        this.questionId = questionId;
        this.answer = answer;
        this.type = type;
    }
}
