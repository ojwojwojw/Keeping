package com.keeping.openaiservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TransactionRequestList {

    private String memberKey;
    
    private List<TransactionRequest> transactionRequsetList;

    @Builder
    public TransactionRequestList(String memberKey, List<TransactionRequest> transactionRequsetList) {
        this.memberKey = memberKey;
        this.transactionRequsetList = transactionRequsetList;
    }
}
