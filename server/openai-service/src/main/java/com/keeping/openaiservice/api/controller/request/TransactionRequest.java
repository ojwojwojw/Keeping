package com.keeping.openaiservice.api.controller.request;

import com.keeping.openaiservice.domain.Category;
import com.keeping.openaiservice.domain.TransactionType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
public class TransactionRequest {
    
    private String storeName;
    
    private TransactionType type;
    
    private Long money;
    
    private Long balance;

    private Category category;
    
    private String address;
    
    private LocalDateTime createdDate;
    
    private boolean detailed;
    
    private List<TransactionDetailRequest> transactionDetailRequestList;

    @Builder
    public TransactionRequest(String storeName, TransactionType type, Long money, Long balance, Category category, String address, LocalDateTime createdDate, boolean detailed, List<TransactionDetailRequest> transactionDetailRequestList) {
        this.storeName = storeName;
        this.type = type;
        this.money = money;
        this.balance = balance;
        this.category = category;
        this.address = address;
        this.createdDate = createdDate;
        this.detailed = detailed;
        this.transactionDetailRequestList = transactionDetailRequestList;
    }
}
