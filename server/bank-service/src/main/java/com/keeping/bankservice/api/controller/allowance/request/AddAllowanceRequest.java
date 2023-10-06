package com.keeping.bankservice.api.controller.allowance.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAllowanceRequest {

    @NotBlank
    private String content;

    @NotNull
    private Integer money;


    @Builder
    private AddAllowanceRequest(String content, Integer money) {
        this.content = content;
        this.money = money;
    }
}
