package com.keeping.notiservice.api.service.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class FCMNotificationDto {
    
    private String memberKey;
    
    private String title;
    
    private String body;

    @Builder
    public FCMNotificationDto(String memberKey, String title, String body) {
        this.memberKey = memberKey;
        this.title = title;
        this.body = body;
    }

    public static FCMNotificationDto toDto(SendNotiDto dto) {
        return FCMNotificationDto.builder()
                .memberKey(dto.getSentKey())
                .title(dto.getTitle())
                .body(dto.getContent())
                .build();
    }
}
