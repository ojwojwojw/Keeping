package com.keeping.missionservice.api.controller.mission.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

@Data
@NoArgsConstructor
public class AccountResponse {
    
    private int balance;

    @Builder
    public AccountResponse(int balance) {
        this.balance = balance;
    }
}
