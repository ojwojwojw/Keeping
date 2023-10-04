package com.keeping.questionservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@NoArgsConstructor
public class QuestionNotiRequest {

    @NotNull
    private String memberKey;

    @NotNull
    private String title;

    @NotNull
    private String body;

    @Builder
    public QuestionNotiRequest(String memberKey, String title, String body) {
        this.memberKey = memberKey;
        this.title = title;
        this.body = body;
    }
}
