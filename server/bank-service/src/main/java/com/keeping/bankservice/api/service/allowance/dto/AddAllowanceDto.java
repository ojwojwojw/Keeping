package com.keeping.bankservice.api.service.allowance.dto;

import com.keeping.bankservice.api.controller.allowance.request.AddAllowanceRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAllowanceDto {

    private String content;
    private int money;


    @Builder
    private AddAllowanceDto(String content, int money) {
        this.content = content;
        this.money = money;
    }

    public static AddAllowanceDto toDto(AddAllowanceRequest request) {
        return AddAllowanceDto.builder()
                .content(request.getContent())
                .money(request.getMoney())
                .build();
    }
}
