package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class QuestionCommentResponse {

    private QuestionResponse question;
    private List<CommentResponse> comments;

    @Builder
    public QuestionCommentResponse(QuestionResponse question, List<CommentResponse> comments) {
        this.question = question;
        this.comments = comments;
    }
}
