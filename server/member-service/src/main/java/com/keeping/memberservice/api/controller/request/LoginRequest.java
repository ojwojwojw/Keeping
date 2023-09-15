package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class LoginRequest {

    private String loginId;
    private String loginPw;

    @Builder
    public LoginRequest(String loginId, String loginPw) {
        this.loginId = loginId;
        this.loginPw = loginPw;
    }
}
