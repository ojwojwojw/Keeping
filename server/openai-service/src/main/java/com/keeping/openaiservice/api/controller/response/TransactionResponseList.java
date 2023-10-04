package com.keeping.openaiservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TransactionResponseList {

    private String parentMemberKey;
    private String childMemberKey;
    
    private List<TransactionResponse> transactionList;

    @Builder
    public TransactionResponseList(String parentMemberKey, String childMemberKey, List<TransactionResponse> transactionList) {
        this.parentMemberKey = parentMemberKey;
        this.childMemberKey = childMemberKey;
        this.transactionList = transactionList;
    }
}
