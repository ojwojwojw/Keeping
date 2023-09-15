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
}
