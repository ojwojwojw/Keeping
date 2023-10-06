package com.keeping.bankservice.api.service.piggy.dto;

import com.keeping.bankservice.domain.piggy.Completed;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

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
    private LocalDateTime createdDate;


    @Builder
    private ShowPiggyDto(Long id, String childKey, String accountNumber, String content, int goalMoney, int balance, String savedImage, Completed completed, LocalDateTime createdDate) {
        this.id = id;
        this.childKey = childKey;
        this.accountNumber = accountNumber;
        this.content = content;
        this.goalMoney = goalMoney;
        this.balance = balance;
        this.savedImage = savedImage;
        this.completed = completed;
        this.createdDate = createdDate;
    }
}
