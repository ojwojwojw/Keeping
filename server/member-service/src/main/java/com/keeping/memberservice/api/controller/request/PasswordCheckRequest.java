package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Data
public class PasswordCheckRequest {

    @NotBlank
    private String memeberKey;
    @NotBlank
    private String loginPw;

    @Builder
    private PasswordCheckRequest(String memeberKey, String loginPw) {
        this.memeberKey = memeberKey;
        this.loginPw = loginPw;
    }
}
