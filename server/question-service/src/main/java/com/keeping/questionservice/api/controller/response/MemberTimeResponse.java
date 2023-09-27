package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

import java.time.LocalTime;

@Data
public class MemberTimeResponse {
    
    private LocalTime registrationTime;


    @Builder
    public MemberTimeResponse(LocalTime registrationTime) {
        this.registrationTime = registrationTime;
    }
}
