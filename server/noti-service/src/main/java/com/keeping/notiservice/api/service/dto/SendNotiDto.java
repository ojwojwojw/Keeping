package com.keeping.notiservice.api.service.dto;

import com.keeping.notiservice.api.controller.request.SendNotiRequest;
import com.keeping.notiservice.domain.noti.Type;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class SendNotiDto {

    private String memberKey;
    
    private String fcmToken;

    private String title;

    private String content;

    private Type type;

    @Builder
    public SendNotiDto(String memberKey, String fcmToken, String title, String content, Type type) {
        this.memberKey = memberKey;
        this.fcmToken = fcmToken;
        this.title = title;
        this.content = content;
        this.type = type;
    }

    public static SendNotiDto toDto(SendNotiRequest request) {
        return SendNotiDto.builder()
                .memberKey(request.getMemberKey())
                .fcmToken(request.getFcmToken())
                .title(request.getTitle())
                .content(request.getContent())
                .type(request.getType())
                .build();
    }
        
        
}
