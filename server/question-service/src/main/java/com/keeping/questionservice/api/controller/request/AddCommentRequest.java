package com.keeping.questionservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@NoArgsConstructor
public class AddCommentRequest {

    @NotNull
    private Long questionId;

    @NotNull
    private String content;


    @Builder
    public AddCommentRequest(Long questionId, String content) {
        this.questionId = questionId;
        this.content = content;
    }
}
