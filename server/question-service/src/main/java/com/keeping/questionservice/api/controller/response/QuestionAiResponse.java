package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class QuestionAiResponse {

    private String parentMemberKey;
    private String childMemberKey;
    private String answer;

    @Builder
    public QuestionAiResponse(String parentMemberKey, String childMemberKey, String answer) {
        this.parentMemberKey = parentMemberKey;
        this.childMemberKey = childMemberKey;
        this.answer = answer;
    }
}
