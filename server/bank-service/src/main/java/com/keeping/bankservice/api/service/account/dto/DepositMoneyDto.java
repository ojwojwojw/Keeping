package com.keeping.bankservice.api.service.account.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class DepositMoneyDto {

    private String accountNumber;
    private Long money;


    @Builder
    private DepositMoneyDto(String accountNumber, Long money) {
        this.accountNumber = accountNumber;
        this.money = money;
    }

    public static DepositMoneyDto toDto(String accountNumber, Long money) {
        return DepositMoneyDto.builder()
                .accountNumber(accountNumber)
                .money(money)
                .build();
    }
}
