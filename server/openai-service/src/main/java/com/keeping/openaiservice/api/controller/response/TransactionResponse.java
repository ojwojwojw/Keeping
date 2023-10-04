package com.keeping.openaiservice.api.controller.response;

import com.keeping.openaiservice.api.controller.request.TransactionDetailRequest;
import com.keeping.openaiservice.domain.LargeCategory;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
public class TransactionResponse {

    private Long id;
    private String storeName;
    
    private boolean type;
    
    private Long money;
    
    private Long balance;

    private Long remain;

    private LargeCategory largeCategory;

    private boolean detailed;

    private String address;

    private double latitude;

    private double longitude;

    private LocalDateTime createdDate;

    private List<TransactionDetailRequest> detailList;

    @Builder
    public TransactionResponse(Long id, String storeName, boolean type, Long money, Long balance, Long remain, LargeCategory largeCategory, boolean detailed, String address, double latitude, double longitude, LocalDateTime createdDate, List<TransactionDetailRequest> detailList) {
        this.id = id;
        this.storeName = storeName;
        this.type = type;
        this.money = money;
        this.balance = balance;
        this.remain = remain;
        this.largeCategory = largeCategory;
        this.detailed = detailed;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.createdDate = createdDate;
        this.detailList = detailList;
    }
}
