package com.keeping.bankservice.api.controller.online.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddOnlineRequest {

    @NotBlank
    private String productName;

    @NotBlank
    private String url;

    @NotBlank
    private String content;

    @NotNull
    private Integer totalMoney;

    @NotNull
    private Integer childMoney;


    @Builder
    private AddOnlineRequest(String productName, String url, String content, int totalMoney, int childMoney) {
        this.productName = productName;
        this.url = url;
        this.content = content;
        this.totalMoney = totalMoney;
        this.childMoney = childMoney;
    }
}
