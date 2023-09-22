package com.keeping.bankservice.api.controller.account_history.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountHistoryRequest {

    @NotBlank
    private String accountNumber;

    @NotBlank
    private String storeName;

    @NotNull
    private Boolean type;

    @NotBlank
    private Long money;

    @NotBlank
    private String address;


    @Builder
    private AddAccountHistoryRequest(String accountNumber, String storeName, boolean type, Long money, String address) {
        this.accountNumber = accountNumber;
        this.storeName = storeName;
        this.type = type;
        this.money = money;
        this.address = address;
    }
}
