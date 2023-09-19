package com.keeping.bankservice.api.service.account_history.dto;

import com.keeping.bankservice.api.controller.account_history.request.AddAccountHistoryRequest;
import com.keeping.bankservice.domain.account.Account;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountHistoryDto {

    private Account account;
    private String storeName;
    private boolean type;
    private Long money;

    @Builder
    private AddAccountHistoryDto(Account account, String storeName, boolean type, Long money) {
        this.account = account;
        this.storeName = storeName;
        this.type = type;
        this.money = money;
    }

    public static AddAccountHistoryDto toDto(AddAccountHistoryRequest request) {
        return AddAccountHistoryDto.builder()
                .account(request.getAccount())
                .storeName(request.getStoreName())
                .type(request.isType())
                .money(request.getMoney())
                .build();
    }

}
