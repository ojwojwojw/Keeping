package com.keeping.questionservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
public class QuestionNotiRequestList {
    
    private List<QuestionNotiRequest> questionNotiRequests;

    @Builder
    public QuestionNotiRequestList(List<QuestionNotiRequest> questionNotiRequests) {
        this.questionNotiRequests = questionNotiRequests;
    }
}
