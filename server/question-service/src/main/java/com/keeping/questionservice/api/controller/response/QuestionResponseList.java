package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class QuestionResponseList {
    
    List<QuestionResponse> questions;

    @Builder
    public QuestionResponseList(List<QuestionResponse> questions) {
        this.questions = questions;
    }
}
