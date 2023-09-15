package com.keeping.bankservice.api.controller.account.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountRequest {

    @NotBlank
    @Size(min = 6, max = 6)
    private String authPassword;


    @Builder
    private AddAccountRequest(String authPassword) {
        this.authPassword = authPassword;
    }
}
