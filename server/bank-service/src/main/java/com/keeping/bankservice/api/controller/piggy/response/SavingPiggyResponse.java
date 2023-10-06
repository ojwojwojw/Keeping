package com.keeping.bankservice.api.controller.piggy.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class SavingPiggyResponse {

    private boolean isCompleted;
    private ShowPiggyResponse piggy;


    @Builder
    private SavingPiggyResponse(boolean isCompleted, ShowPiggyResponse piggy) {
        this.isCompleted = isCompleted;
        this.piggy = piggy;
    }

    public static SavingPiggyResponse toResponse(boolean isCompleted, ShowPiggyResponse piggy) {
        return SavingPiggyResponse.builder()
                .isCompleted(isCompleted)
                .piggy(piggy)
                .build();
    }
}
