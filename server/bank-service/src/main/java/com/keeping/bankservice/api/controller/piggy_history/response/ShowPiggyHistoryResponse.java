package com.keeping.bankservice.api.controller.piggy_history.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class ShowPiggyHistoryResponse {

    private Long id;
    private String name;
    private int money;
    private int balance;
    private LocalDateTime createdDate;


    @Builder
    public ShowPiggyHistoryResponse(Long id, String name, int money, int balance, LocalDateTime createdDate) {
        this.id = id;
        this.name = name;
        this.money = money;
        this.balance = balance;
        this.createdDate = createdDate;
    }
}
