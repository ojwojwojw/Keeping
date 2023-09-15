package com.keeping.bankservice.api.service.account.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class WithdrawMoneyDto {

    private String accountNumber;
    private int money;


    @Builder
    private WithdrawMoneyDto(String accountNumber, int money) {
        this.accountNumber = accountNumber;
        this.money = money;
    }

    public static WithdrawMoneyDto toDto(String accountNumber, int money) {
        return WithdrawMoneyDto.builder()
                .accountNumber(accountNumber)
                .money(money)
                .build();
    }
}
