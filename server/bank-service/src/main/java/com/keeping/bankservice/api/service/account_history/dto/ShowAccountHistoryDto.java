package com.keeping.bankservice.api.service.account_history.dto;

import com.keeping.bankservice.domain.account_history.LargeCategory;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class ShowAccountHistoryDto {

    private Long id;
    private String storeName;
    private boolean type;
    private Long money;
    private Long balance;
    private Long remain;
    private LargeCategory largeCategory;
    private boolean detailed;
    private String address;
    private Double latitude;
    private Double longitude;
    private LocalDateTime createdDate;


    @Builder
    public ShowAccountHistoryDto(Long id, String storeName, boolean type, Long money, Long balance, Long remain, LargeCategory largeCategory, boolean detailed, String address, Double latitude, Double longitude, LocalDateTime createdDate) {
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
    }
}