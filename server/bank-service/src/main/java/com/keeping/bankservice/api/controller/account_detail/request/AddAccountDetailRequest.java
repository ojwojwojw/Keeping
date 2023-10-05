package com.keeping.bankservice.api.controller.account_detail.request;


import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import java.util.List;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountDetailRequest {

    @NotNull
    List<AccountDetailRequest> accountDetailList;


    @Builder
    private AddAccountDetailRequest(List<AccountDetailRequest> accountDetailList) {
        this.accountDetailList = accountDetailList;
    }
}
