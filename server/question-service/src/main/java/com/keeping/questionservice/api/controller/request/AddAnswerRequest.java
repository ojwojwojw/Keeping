package com.keeping.questionservice.api.controller.request;

import com.keeping.questionservice.domain.MemberType;
import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
public class AddAnswerRequest {

    @NotBlank
    private Long questionId;
    @NotBlank
    private String answer;
    @NotNull
    private boolean isCreated;

    @Builder
    public AddAnswerRequest(Long questionId, String answer, boolean isCreated) {
        this.questionId = questionId;
        this.answer = answer;
        this.isCreated = isCreated;
    }
}
