package com.keeping.openaiservice.api.controller.request;

import com.keeping.openaiservice.api.controller.response.TransactionResponseList;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TransactionTotalList {
    private List<TransactionResponseList> transactionResponseLists;

    @Builder
    public TransactionTotalList(List<TransactionResponseList> transactionResponseLists) {
        this.transactionResponseLists = transactionResponseLists;
    }
}
