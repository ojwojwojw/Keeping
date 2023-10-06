package com.keeping.bankservice.api.service.account_history.dto;

import com.keeping.bankservice.api.controller.account_history.request.TransferMoneyRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class TransferToParentDto {

    private String parentKey;
    private int money;


    @Builder
    private TransferToParentDto(String parentKey, int money) {
        this.parentKey = parentKey;
        this.money = money;
    }

    public static TransferToParentDto toDto(String parentKey, int money) {
        return TransferToParentDto.builder()
                .parentKey(parentKey)
                .money(money)
                .build();
    }
}
