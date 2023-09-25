package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TodayQuestionResponse {

    private Long id;

    private String content;

    private boolean isCreated;

    private String parentAnswer;

    private String childAnswer;

    private List<CommentResponse> commentResponseList;

    @Builder
    public TodayQuestionResponse(Long id, String content, boolean isCreated, String parentAnswer, String childAnswer, List<CommentResponse> commentResponseList) {
        this.id = id;
        this.content = content;
        this.isCreated = isCreated;
        this.parentAnswer = parentAnswer;
        this.childAnswer = childAnswer;
        this.commentResponseList = commentResponseList;
    }

    public static TodayQuestionResponse toDto(Long id, String content, boolean isCreated, String parentAnswer, String childAnswer, List<CommentResponse> commentResponseList) {
        return TodayQuestionResponse.builder()
                .id(id)
                .content(content)
                .isCreated(isCreated)
                .parentAnswer(parentAnswer)
                .childAnswer(childAnswer)
                .commentResponseList(commentResponseList)
                .build();
    }

}
