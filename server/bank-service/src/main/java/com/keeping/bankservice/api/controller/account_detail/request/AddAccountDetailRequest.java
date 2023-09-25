package com.keeping.bankservice.api.controller.account_detail.request;


import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountDetailRequest {

    @NotNull
    private Long accountHistoryId;

    @NotBlank
    private String content;

    @NotNull
    private Long money;


    @Builder
    private AddAccountDetailRequest(Long accountHistoryId, String content, Long money) {
        this.accountHistoryId = accountHistoryId;
        this.content = content;
        this.money = money;
    }
}
