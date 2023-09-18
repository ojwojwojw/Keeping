package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

@Data
public class SmsCheckRequest {

    private String phone;
    private String certification;

    @Builder
    public SmsCheckRequest(String phone, String certification) {
        this.phone = phone;
        this.certification = certification;
    }
}
