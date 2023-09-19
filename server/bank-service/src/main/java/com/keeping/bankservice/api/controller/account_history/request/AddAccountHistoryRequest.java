package com.keeping.bankservice.api.controller.account_history.request;

import com.keeping.bankservice.domain.account.Account;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountHistoryRequest {

    @NotBlank
    private Account account;

    @NotBlank
    private String storeName;

    @NotBlank
    private boolean type;

    @NotBlank
    private Long money;


    @Builder
    private AddAccountHistoryRequest(Account account, String storeName, boolean type, Long money) {
        this.account = account;
        this.storeName = storeName;
        this.type = type;
        this.money = money;
    }
}
