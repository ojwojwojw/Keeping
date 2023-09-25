package com.keeping.notiservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class QuestionNotiRequestList {
    
    private List<QuestionNotiRequest> requestList;

    @Builder
    public QuestionNotiRequestList(List<QuestionNotiRequest> requestList) {
        this.requestList = requestList;
    }
}
