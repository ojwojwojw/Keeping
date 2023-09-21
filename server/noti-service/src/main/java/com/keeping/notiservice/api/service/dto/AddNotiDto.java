package com.keeping.notiservice.api.service.dto;

import com.keeping.notiservice.domain.noti.Type;
import lombok.Builder;
import lombok.Data;

@Data
public class AddNotiDto {
    
    private String memberKey;
    
    private String receptionkey;
    
    private String sentKey;
    
    private String title;
    
    private String content;
    
    private Type type;

    @Builder
    public AddNotiDto(String memberKey, String receptionkey, String sentKey, String title, String content, Type type) {
        this.memberKey = memberKey;
        this.receptionkey = receptionkey;
        this.sentKey = sentKey;
        this.title = title;
        this.content = content;
        this.type = type;
    }

    public static AddNotiDto toDto(SendNotiDto dto) {
        return AddNotiDto.builder()
                .memberKey(dto.getMemberKey())
                .receptionkey(dto.getReceptionkey())
                .sentKey(dto.getSentKey())
                .title(dto.getTitle())
                .content(dto.getContent())
                .type(dto.getType())
                .build();
    } 
}
