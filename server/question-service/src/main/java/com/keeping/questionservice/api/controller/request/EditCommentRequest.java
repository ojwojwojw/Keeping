package com.keeping.questionservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@NoArgsConstructor
public class EditCommentRequest {

    @NotNull
    private Long questionId;

    @NotNull
    private Long commentId;

    @NotNull
    private String content;

    @Builder
    public EditCommentRequest(Long questionId, Long commentId, String content) {
        this.questionId = questionId;
        this.commentId = commentId;
        this.content = content;
    }

}
