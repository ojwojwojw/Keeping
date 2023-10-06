package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

import java.time.LocalTime;

@Data
public class QuestionTimeResponse {
    private LocalTime registrationTime;

    @Builder
    private QuestionTimeResponse(LocalTime registrationTime) {
        this.registrationTime = registrationTime;
    }
}
