package com.keeping.bankservice.api.controller.account_history.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class CountMonthExpenseResponse {

    private Long sum;
    private Long balance;


    @Builder
    private CountMonthExpenseResponse(Long sum, Long balance) {
        this.sum = sum;
        this.balance = balance;
    }

    public static CountMonthExpenseResponse toResponse(Long sum, Long balance) {
        return CountMonthExpenseResponse.builder()
                .sum(sum)
                .balance(balance)
                .build();
    }
}
