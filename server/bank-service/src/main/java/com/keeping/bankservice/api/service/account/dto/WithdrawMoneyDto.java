package com.keeping.bankservice.api.service.account.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class WithdrawMoneyDto {

    private String accountNumber;
    private Long money;


    @Builder
    private WithdrawMoneyDto(String accountNumber, Long money) {
        this.accountNumber = accountNumber;
        this.money = money;
    }

    public static WithdrawMoneyDto toDto(String accountNumber, Long money) {
        return WithdrawMoneyDto.builder()
                .accountNumber(accountNumber)
                .money(money)
                .build();
    }
}
