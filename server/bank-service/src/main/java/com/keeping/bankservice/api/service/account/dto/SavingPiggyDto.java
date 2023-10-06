package com.keeping.bankservice.api.service.account.dto;

import com.keeping.bankservice.api.controller.piggy.request.SavingPiggyRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class SavingPiggyDto {

    private String accountNumber;
    private String piggyAccountNumber;
    private int money;
    private String authPassword;


    @Builder
    private SavingPiggyDto(String accountNumber, String piggyAccountNumber, int money, String authPassword) {
        this.accountNumber = accountNumber;
        this.piggyAccountNumber = piggyAccountNumber;
        this.money = money;
        this.authPassword = authPassword;
    }

    public static SavingPiggyDto toDto(SavingPiggyRequest request) {
        return SavingPiggyDto.builder()
                .accountNumber(request.getAccountNumber())
                .piggyAccountNumber(request.getPiggyAccountNumber())
                .money(request.getMoney())
                .authPassword(request.getAuthPassword())
                .build();
    }
}
