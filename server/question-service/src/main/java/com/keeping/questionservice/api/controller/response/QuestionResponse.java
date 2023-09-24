package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class QuestionResponse {

    private Long id;
    private String content;
    private String parentAnswer;
    private String childAnswer;
    private boolean isCreated;
    private LocalDateTime createdDate;

    @Setter
    private List<CommentResponse> comments;

    @Builder
    public QuestionResponse(Long id, String content, String parentAnswer, String childAnswer, boolean isCreated, LocalDateTime createdDate, List<CommentResponse> comments) {
        this.id = id;
        this.content = content;
        this.parentAnswer = parentAnswer;
        this.childAnswer = childAnswer;
        this.isCreated = isCreated;
        this.createdDate = createdDate;
        this.comments = comments;
    }
}
