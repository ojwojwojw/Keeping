package com.keeping.bankservice.api.service.account_history.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class KeywordResponseDto {

    private String address_name;
    private String categoryGroupCode;
    private String categoryGroupName;
    private String categoryName;
    private String distance;
    private int id;
    private String phone;
    private String placeName;
    private String placeUrl;
    private String roadAddressName;
    private Double x;
    private Double y;
}
