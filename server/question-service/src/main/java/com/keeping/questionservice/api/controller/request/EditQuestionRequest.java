package com.keeping.questionservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Data
public class EditQuestionRequest {

    @NotBlank
    private Long questionId;
    @NotBlank
    private String childMemberKey;
    @NotBlank
    private String content;

    @Builder
    public EditQuestionRequest(Long questionId, String childMemberKey, String content) {
        this.questionId = questionId;
        this.childMemberKey = childMemberKey;
        this.content = content;
    }
}
