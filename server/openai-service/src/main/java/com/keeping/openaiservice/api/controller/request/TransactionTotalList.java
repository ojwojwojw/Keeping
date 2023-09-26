package com.keeping.openaiservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TransactionTotalList {
    private List<TransactionRequestList> transactionRequestLists;

    @Builder
    public TransactionTotalList(List<TransactionRequestList> transactionRequestLists) {
        this.transactionRequestLists = transactionRequestLists;
    }
}
