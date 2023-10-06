package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalTime;

@Data
public class MemberTimeResponse {
    
    private LocalTime registrationTime;

}
