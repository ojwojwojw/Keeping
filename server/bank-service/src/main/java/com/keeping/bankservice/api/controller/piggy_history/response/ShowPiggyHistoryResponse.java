package com.keeping.bankservice.api.controller.piggy_history.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ShowPiggyHistoryResponse {

    private Long id;
    private String name;
    private int money;
    private int balance;


    @Builder
    public ShowPiggyHistoryResponse(Long id, String name, int money, int balance) {
        this.id = id;
        this.name = name;
        this.money = money;
        this.balance = balance;
    }
}
