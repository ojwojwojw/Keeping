package com.keeping.bankservice.api.controller.regular_allowance.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class MakeRegularAllowanceRequest {

    @NotBlank
    private String childKey;

    @NotNull
    private Integer money;

    @NotNull
    private Integer day;


    @Builder
    private MakeRegularAllowanceRequest(String childKey, Integer money, Integer day) {
        this.childKey = childKey;
        this.money = money;
        this.day = day;
    }
}
