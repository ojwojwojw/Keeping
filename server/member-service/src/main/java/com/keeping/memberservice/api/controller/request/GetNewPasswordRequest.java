package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

@Data
public class GetNewPasswordRequest {

    private String type;
    private String loginId;
    private String phone;

    @Builder
    private GetNewPasswordRequest(String type, String loginId, String phone) {
        this.type = type;
        this.loginId = loginId;
        this.phone = phone;
    }
}
