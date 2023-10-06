package com.keeping.bankservice.api.service.account_history.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountDetailValidationDto {

    private Long accountHistoryId;
    private Long money;


    @Builder
    private AddAccountDetailValidationDto(Long accountHistoryId, Long money) {
        this.accountHistoryId = accountHistoryId;
        this.money = money;
    }

    public static AddAccountDetailValidationDto toDto(Long accountHistoryId, Long money) {
        return AddAccountDetailValidationDto.builder()
                .accountHistoryId(accountHistoryId)
                .money(money)
                .build();
    }
}
