package com.keeping.bankservice.api.service.account_history.dto;

import com.keeping.bankservice.api.controller.account_history.request.TransferMoneyRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class TransferMoneyDto {

    private String childKey;
    private int money;


    @Builder
    private TransferMoneyDto(String childKey, int money) {
        this.childKey = childKey;
        this.money = money;
    }

    public static TransferMoneyDto toDto(TransferMoneyRequest request) {
        return TransferMoneyDto.builder()
                .childKey(request.getChildKey())
                .money(request.getMoney())
                .build();
    }

    public static TransferMoneyDto toDto(String childKey, int money) {
        return TransferMoneyDto.builder()
                .childKey(childKey)
                .money(money)
                .build();
    }
}
