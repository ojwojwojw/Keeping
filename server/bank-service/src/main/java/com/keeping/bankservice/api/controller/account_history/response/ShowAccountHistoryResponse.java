package com.keeping.bankservice.api.controller.account_history.response;

import com.keeping.bankservice.api.service.account_detail.dto.ShowAccountDetailDto;
import com.keeping.bankservice.api.service.account_history.dto.ShowAccountHistoryDto;
import com.keeping.bankservice.domain.account_history.LargeCategory;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class ShowAccountHistoryResponse {

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
    private List<ShowAccountDetailDto> detailList;


    @Builder
    private ShowAccountHistoryResponse(Long id, String storeName, boolean type, Long money, Long balance, Long remain, LargeCategory largeCategory, boolean detailed, String address, Double latitude, Double longitude, LocalDateTime createdDate, List<ShowAccountDetailDto> detailList) {
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

    public static ShowAccountHistoryResponse toResponse(ShowAccountHistoryDto dto, List<ShowAccountDetailDto> detailList) {
        return ShowAccountHistoryResponse.builder()
                .id(dto.getId())
                .storeName(dto.getStoreName())
                .type(dto.isType())
                .money(dto.getMoney())
                .balance(dto.getBalance())
                .remain(dto.getRemain())
                .largeCategory(dto.getLargeCategory())
                .detailed(dto.isDetailed())
                .address(dto.getAddress())
                .latitude(dto.getLatitude())
                .longitude(dto.getLongitude())
                .createdDate(dto.getCreatedDate())
                .detailList(detailList)
                .build();
    }
}
