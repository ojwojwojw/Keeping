package com.keeping.bankservice.api.service.piggy_history.dto;

import com.keeping.bankservice.domain.piggy.Piggy;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddPiggyHistoryDto {

    private Piggy piggy;
    private int money;
    private int balance;


    @Builder
    private AddPiggyHistoryDto(Piggy piggy, int money, int balance) {
        this.piggy = piggy;
        this.money = money;
    }

    public static AddPiggyHistoryDto toDto(Piggy piggy, int money, int balance) {
        return AddPiggyHistoryDto.builder()
                .piggy(piggy)
                .money(money)
                .balance(balance)
                .build();
    }

}
