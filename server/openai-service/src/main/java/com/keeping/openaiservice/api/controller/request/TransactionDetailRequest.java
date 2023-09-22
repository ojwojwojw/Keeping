package com.keeping.openaiservice.api.controller.request;

import com.keeping.openaiservice.domain.Category;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class TransactionDetailRequest {
    
    private String content;
    
    private Long money;
    
    private Category category;

    @Builder
    public TransactionDetailRequest(String content, Long money, Category category) {
        this.content = content;
        this.money = money;
        this.category = category;
    }
}
