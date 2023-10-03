package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TodayQuestionCommentResponse {

    private Long id;
    private String memberKey;

    private String content;

    private boolean isCreated;

    private String parentAnswer;

    private String childAnswer;

    private List<CommentResponse> commentResponseList;

    @Builder
    public TodayQuestionCommentResponse(Long id, String memberKey, String content, boolean isCreated, String parentAnswer, String childAnswer, List<CommentResponse> commentResponseList) {
        this.id = id;
        this.memberKey = memberKey;
        this.content = content;
        this.isCreated = isCreated;
        this.parentAnswer = parentAnswer;
        this.childAnswer = childAnswer;
        this.commentResponseList = commentResponseList;
    }

    public static TodayQuestionCommentResponse toDto(Long id, String memberKey, String content, boolean isCreated, String parentAnswer, String childAnswer, List<CommentResponse> commentResponseList) {
        return TodayQuestionCommentResponse.builder()
                .id(id)
                .memberKey(memberKey)
                .content(content)
                .isCreated(isCreated)
                .parentAnswer(parentAnswer)
                .childAnswer(childAnswer)
                .commentResponseList(commentResponseList)
                .build();
    }

}
