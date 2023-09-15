package com.keeping.bankservice.api.service.piggy.dto;

import com.keeping.bankservice.domain.piggy.Completed;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ShowPiggyDto {

    private Long id;
    private String childKey;
    private String accountNumber;
    private String content;
    private int goalMoney;
    private int balance;
    private String savedImage;
    private Completed completed;


    @Builder
    private ShowPiggyDto(Long id, String childKey, String accountNumber, String content, int goalMoney, int balance, String savedImage, Completed completed) {
        this.id = id;
        this.childKey = childKey;
        this.accountNumber = accountNumber;
        this.content = content;
        this.goalMoney = goalMoney;
        this.balance = balance;
        this.savedImage = savedImage;
        this.completed = completed;
    }
}
