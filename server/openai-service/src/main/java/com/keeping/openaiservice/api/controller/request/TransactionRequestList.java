package com.keeping.openaiservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TransactionRequestList {
    
    private List<TransactionRequest> transactionRequsetList;

    @Builder
    public TransactionRequestList(List<TransactionRequest> transactionRequsetList) {
        this.transactionRequsetList = transactionRequsetList;
    }
}
