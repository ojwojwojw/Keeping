package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class QuestionResponseList {
    
    List<QuestionResponse> questionResponseList;

    @Builder
    public QuestionResponseList(List<QuestionResponse> questionResponseList) {
        this.questionResponseList = questionResponseList;
    }
}
