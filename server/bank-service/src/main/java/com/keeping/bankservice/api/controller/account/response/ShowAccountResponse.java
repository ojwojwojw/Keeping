package com.keeping.bankservice.api.controller.account.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor()
public class ShowAccountResponse {

    private Long id;
    private String accountNumber;
    private Long balance;
    private LocalDateTime createdDate;


    @Builder
    public ShowAccountResponse(Long id, String accountNumber, Long balance, LocalDateTime createdDate) {
        this.id = id;
        this.accountNumber = accountNumber;
        this.balance = balance;
        this.createdDate = createdDate;
    }
}
