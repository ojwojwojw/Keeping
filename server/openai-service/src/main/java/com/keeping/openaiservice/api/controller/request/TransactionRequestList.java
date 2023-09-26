package com.keeping.openaiservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TransactionRequestList {

    private String parentMemberKey;
    private String childMemberKey;
    
    private List<TransactionRequest> transactionRequsetList;

    @Builder
    public TransactionRequestList(String parentMemberKey, String childMemberKey, List<TransactionRequest> transactionRequsetList) {
        this.parentMemberKey = parentMemberKey;
        this.childMemberKey = childMemberKey;
        this.transactionRequsetList = transactionRequsetList;
    }
}
