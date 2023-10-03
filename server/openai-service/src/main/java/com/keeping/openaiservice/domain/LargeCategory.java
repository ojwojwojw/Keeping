package com.keeping.openaiservice.domain;

import lombok.Getter;

@Getter
public enum LargeCategory {
    MART("마트"),
    CONVENIENCE("편의점"),
    SCHOOL("학교"),
    ACADEMY("학원"),
    PARKING("주차"),
    SUBWAY("지하철"),
    BANK("은행"),
    CULTURE("문화/예술"),
    TOUR("여행"),
    FOOD("음식"),
    CAFE("카페"),
    HOSPITAL("병원"),
    PHARMACY("약국"),
    ETC("기타");


    private final String text;

    LargeCategory(String text) {
        this.text = text;
    }
}
