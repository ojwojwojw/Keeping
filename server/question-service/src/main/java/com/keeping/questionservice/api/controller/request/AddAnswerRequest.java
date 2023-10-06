package com.keeping.questionservice.api.controller.request;

import com.keeping.questionservice.domain.MemberType;
import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
public class AddAnswerRequest {

    @NotNull
    private boolean isParent;

    @NotNull
    private Long questionId;
    @NotBlank
    private String answer;

    @Builder
    public AddAnswerRequest(boolean isParent, Long questionId, String answer) {
        this.isParent = isParent;
        this.questionId = questionId;
        this.answer = answer;
    }
}
