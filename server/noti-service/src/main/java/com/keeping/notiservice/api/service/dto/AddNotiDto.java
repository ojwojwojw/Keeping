package com.keeping.notiservice.api.service.dto;

import com.keeping.notiservice.api.controller.request.QuestionNotiRequest;
import com.keeping.notiservice.domain.noti.Type;
import lombok.Builder;
import lombok.Data;

@Data
public class AddNotiDto {
    
    private String memberKey;
    
    private String fcmToken;
    
    private String title;
    
    private String content;
    
    private Type type;

    @Builder
    public AddNotiDto(String memberKey, String fcmToken, String title, String content, Type type) {
        this.memberKey = memberKey;
        this.fcmToken = fcmToken;
        this.title = title;
        this.content = content;
        this.type = type;
    }

    public static AddNotiDto toDto(SendNotiDto dto, String fcmToken) {
        return AddNotiDto.builder()
                .memberKey(dto.getMemberKey())
                .fcmToken(fcmToken)
                .title(dto.getTitle())
                .content(dto.getContent())
                .type(dto.getType())
                .build();
    }

    public static AddNotiDto toDto(QuestionNotiRequest request, String fcmToken) {
        return AddNotiDto.builder()
                .memberKey(request.getMemberKey())
                .fcmToken(fcmToken)
                .title(request.getTitle())
                .content(request.getBody())
                .type(Type.QUESTION)
                .build();
                
    }
}
