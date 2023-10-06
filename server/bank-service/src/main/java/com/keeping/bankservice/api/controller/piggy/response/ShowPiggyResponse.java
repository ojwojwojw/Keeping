package com.keeping.bankservice.api.controller.piggy.response;

import com.keeping.bankservice.api.service.piggy.dto.ShowPiggyDto;
import com.keeping.bankservice.domain.piggy.Completed;
import com.keeping.bankservice.domain.piggy.Piggy;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

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
    private String savedImage;
    private Completed completed;
    private LocalDateTime createdDate;


    @Builder
    private ShowPiggyResponse(Long id, String childKey, String accountNumber, String content, int goalMoney, int balance, String savedImage, Completed completed, LocalDateTime createdDate) {
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

    public static ShowPiggyResponse toResponse(ShowPiggyDto dto, String base64Image) {
        return ShowPiggyResponse.builder()
                .id(dto.getId())
                .childKey(dto.getChildKey())
                .accountNumber(dto.getAccountNumber())
                .content(dto.getContent())
                .goalMoney(dto.getGoalMoney())
                .balance(dto.getBalance())
                .savedImage(base64Image)
                .completed(dto.getCompleted())
                .createdDate(dto.getCreatedDate())
                .build();
    }

    public static ShowPiggyResponse toResponse(Piggy piggy, String base64Image) {
        return ShowPiggyResponse.builder()
                .id(piggy.getId())
                .childKey(piggy.getChildKey())
                .accountNumber(piggy.getAccountNumber())
                .content(piggy.getContent())
                .goalMoney(piggy.getGoalMoney())
                .balance(piggy.getBalance())
                .savedImage(base64Image)
                .completed(piggy.getCompleted())
                .createdDate(piggy.getCreatedDate())
                .build();
    }
}
