package com.keeping.bankservice.api.controller.account_history.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class TransferMoneyRequest {

    @NotBlank
    private String childKey;

    @NotBlank
    private Integer money;


    @Builder
    private TransferMoneyRequest(String childKey, Integer money) {
        this.childKey = childKey;
        this.money = money;
    }

}
