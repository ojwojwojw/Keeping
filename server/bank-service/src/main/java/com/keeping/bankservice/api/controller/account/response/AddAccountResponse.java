package com.keeping.bankservice.api.controller.account.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountResponse {

    private Long id;
    private String accountNumber;
    private LocalDateTime createdDate;


    @Builder
    private AddAccountResponse(Long id, String accountNumber, LocalDateTime createdDate) {
        this.id = id;
        this.accountNumber = accountNumber;
        this.createdDate = createdDate;
    }

    public static AddAccountResponse toResponse(Long id, String accountNumber, LocalDateTime createdDate) {
        return AddAccountResponse.builder()
                .id(id)
                .accountNumber(accountNumber)
                .createdDate(createdDate)
                .build();
    }
}
