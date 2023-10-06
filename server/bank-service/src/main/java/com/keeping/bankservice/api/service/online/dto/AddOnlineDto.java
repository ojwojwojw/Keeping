package com.keeping.bankservice.api.service.online.dto;

import com.keeping.bankservice.api.controller.online.request.AddOnlineRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddOnlineDto {

    private String productName;
    private String url;
    private String content;
    private int totalMoney;
    private int childMoney;


    @Builder
    private AddOnlineDto(String productName, String  url, String  content, int totalMoney, int childMoney) {
        this.productName = productName;
        this.url = url;
        this.content = content;
        this.totalMoney = totalMoney;
        this.childMoney = childMoney;
    }

    public static AddOnlineDto toDto(AddOnlineRequest request) {
        return AddOnlineDto.builder()
                .productName(request.getProductName())
                .url(request.getUrl())
                .content(request.getContent())
                .totalMoney(request.getTotalMoney())
                .childMoney(request.getChildMoney())
                .build();
    }

}
