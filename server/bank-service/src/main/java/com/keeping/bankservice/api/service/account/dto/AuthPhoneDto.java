package com.keeping.bankservice.api.service.account.dto;

import com.keeping.bankservice.api.controller.account.request.AuthPhoneRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AuthPhoneDto {

    private String code;


    @Builder
    private AuthPhoneDto(String code) {
        this.code = code;
    }

    public static AuthPhoneDto toDto(AuthPhoneRequest request) {
        return AuthPhoneDto.builder()
                .code(request.getCode())
                .build();
    }
}
