package com.keeping.questionservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class QuestionNotiRequest {
    
    private String memberKey;
    
    private String title;
    
    private String body;

    @Builder
    public QuestionNotiRequest(String memberKey, String title, String body) {
        this.memberKey = memberKey;
        this.title = title;
        this.body = body;
    }
}
