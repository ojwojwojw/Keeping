package com.keeping.bankservice.api.service.account_detail.dto;

import com.keeping.bankservice.api.controller.account_detail.request.AddAccountDetailRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountDetailDto {

    private Long accountHistoryId;
    private String content;
    private Long money;


    @Builder
    private AddAccountDetailDto(Long accountHistoryId, String content, Long money) {
        this.accountHistoryId = accountHistoryId;
        this.content = content;
        this.money = money;
    }

    public static AddAccountDetailDto toDto(AddAccountDetailRequest request) {
        return AddAccountDetailDto.builder()
                .accountHistoryId(request.getAccountHistoryId())
                .content(request.getContent())
                .money(request.getMoney())
                .build();
    }
}
