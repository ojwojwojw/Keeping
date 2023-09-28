package com.keeping.bankservice.api.controller.account_detail.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AccountDetailRequest {

    @NotNull
    private Long accountHistoryId;

    @NotBlank
    private String content;

    @NotNull
    private Long money;

    private String smallCategory;


    @Builder
    private AccountDetailRequest(Long accountHistoryId, String content, Long money, String smallCategory) {
        this.accountHistoryId = accountHistoryId;
        this.content = content;
        this.money = money;
        this.smallCategory = smallCategory;
    }
}
