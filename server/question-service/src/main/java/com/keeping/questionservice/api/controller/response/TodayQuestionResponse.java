package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TodayQuestionResponse {

    private Long id;

    private String content;

    private boolean isCreated;

    private String parentAnswer;

    private String childAnswer;

    @Builder
    public TodayQuestionResponse(Long id, String content, boolean isCreated, String parentAnswer, String childAnswer) {
        this.id = id;
        this.content = content;
        this.isCreated = isCreated;
        this.parentAnswer = parentAnswer;
        this.childAnswer = childAnswer;
    }

    public static TodayQuestionResponse toDto(Long id, String content, boolean isCreated, String parentAnswer, String childAnswer) {
        return TodayQuestionResponse.builder()
                .id(id)
                .content(content)
                .isCreated(isCreated)
                .parentAnswer(parentAnswer)
                .childAnswer(childAnswer)
                .build();
    }

}
