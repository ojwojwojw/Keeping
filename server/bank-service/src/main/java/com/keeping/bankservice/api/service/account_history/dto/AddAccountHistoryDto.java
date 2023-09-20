package com.keeping.bankservice.api.service.account_history.dto;

import com.keeping.bankservice.api.controller.account_history.request.AddAccountHistoryRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountHistoryDto {

    private String accountNumber;
    private String storeName;
    private boolean type;
    private Long money;
    private String address;


    @Builder
    private AddAccountHistoryDto(String accountNumber, String storeName, boolean type, Long money, String address) {
        this.accountNumber = accountNumber;
        this.storeName = storeName;
        this.type = type;
        this.money = money;
        this.address = address;
    }

    public static AddAccountHistoryDto toDto(AddAccountHistoryRequest request) {
        return AddAccountHistoryDto.builder()
                .accountNumber(request.getAccountNumber())
                .storeName(request.getStoreName())
                .type(request.getType())
                .money(request.getMoney())
                .address(request.getAddress())
                .build();
    }

}
