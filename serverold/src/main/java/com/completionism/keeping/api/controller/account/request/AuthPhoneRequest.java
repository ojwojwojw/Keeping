package com.completionism.keeping.api.controller.account.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AuthPhoneRequest {

    @NotBlank
    private String code;


    @Builder
    private AuthPhoneRequest(String code) {
        this.code = code;
    }
}
