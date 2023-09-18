package com.keeping.bankservice.api.controller.piggy.request;

import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class SavingPiggyRequest {

    @NotBlank
    private String accountNumber;

    @NotBlank
    private String piggyAccountNumber;

    @NotBlank
    private int money;

    @NotBlank
    private String authPassword;
}
