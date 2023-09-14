package com.completionism.keeping.api.controller.account.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class CheckPhoneRequest {

    @NotBlank
    private String phone;


    @Builder
    private CheckPhoneRequest(String phone) {
        this.phone = phone;
    }
}
