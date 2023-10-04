package com.keeping.openaiservice.api.controller.request;

import com.keeping.openaiservice.domain.LargeCategory;
import com.keeping.openaiservice.domain.SmallCategory;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TransactionDetailRequest {

    private Long id;

    private String content;
    
    private Long money;
    
    private SmallCategory smallCategory;

    @Builder
    public TransactionDetailRequest(Long id, String content, Long money, SmallCategory smallCategory) {
        this.id = id;
        this.content = content;
        this.money = money;
        this.smallCategory = smallCategory;
    }
}
