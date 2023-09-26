package com.keeping.bankservice.api.controller.account.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor()
public class ShowAccountResponse {

    private Long accountId;
    private String accountNumber;
    private Long balance;
    private LocalDateTime createdDate;


    @Builder
    public ShowAccountResponse(Long accountId, String accountNumber, Long balance, LocalDateTime createdDate) {
        this.accountId = accountId;
        this.accountNumber = accountNumber;
        this.balance = balance;
        this.createdDate = createdDate;
    }
}
