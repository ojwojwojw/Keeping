package com.keeping.bankservice.api.service.regular_allowance.dto;

import com.keeping.bankservice.api.controller.regular_allowance.request.MakeRegularAllowanceRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class MakeRegularAllowanceDto {

    private String childKey;
    private int money;
    private int day;


    @Builder
    private MakeRegularAllowanceDto(String childKey, int money, int day) {
        this.childKey = childKey;
        this.money = money;
        this.day = day;
    }

    public static MakeRegularAllowanceDto toDto(MakeRegularAllowanceRequest request) {
        return MakeRegularAllowanceDto.builder()
                .childKey(request.getChildKey())
                .money(request.getMoney())
                .day(request.getDay())
                .build();
    }
}
