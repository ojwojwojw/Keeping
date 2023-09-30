package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class QuestionResponse {

    private Long id;
    private String content;
    private String parentAnswer;
    private String childAnswer;
    private boolean isCreated;
    private LocalDateTime createdDate;

    @Builder
    public QuestionResponse(Long id, String content, String parentAnswer, String childAnswer, boolean isCreated, LocalDateTime createdDate) {
        this.id = id;
        this.content = content;
        this.parentAnswer = parentAnswer;
        this.childAnswer = childAnswer;
        this.isCreated = isCreated;
        this.createdDate = createdDate;
    }
}
