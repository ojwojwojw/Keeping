package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Data
public class SetFcmTokenRequest {

    @NotBlank
    private String fcmToken;

    @Builder
    private SetFcmTokenRequest(String fcmToken) {
        this.fcmToken = fcmToken;
    }
}
