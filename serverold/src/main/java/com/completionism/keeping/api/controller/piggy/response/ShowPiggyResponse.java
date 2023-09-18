package com.completionism.keeping.api.controller.piggy.response;

import com.completionism.keeping.api.service.piggy.dto.ShowPiggyDto;
import com.completionism.keeping.domain.piggy.Completed;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class ShowPiggyResponse {

    private Long id;
    private String childKey;
    private String accountNumber;
    private String content;
    private int goalMoney;
    private int balance;
    private byte[] savedImage;
    private Completed completed;


    @Builder
    private ShowPiggyResponse(Long id, String childKey, String accountNumber, String content, int goalMoney, int balance, byte[] savedImage, Completed completed) {
        this.id = id;
        this.childKey = childKey;
        this.accountNumber = accountNumber;
        this.content = content;
        this.goalMoney = goalMoney;
        this.balance = balance;
        this.savedImage = savedImage;
        this.completed = completed;
    }

    public static ShowPiggyResponse toResponse(ShowPiggyDto dto, byte[] savedImage) {
        return ShowPiggyResponse.builder()
                .id(dto.getId())
                .childKey(dto.getChildKey())
                .accountNumber(dto.getAccountNumber())
                .content(dto.getContent())
                .goalMoney(dto.getGoalMoney())
                .balance(dto.getBalance())
                .savedImage(savedImage)
                .completed(dto.getCompleted())
                .build();
    }
}
