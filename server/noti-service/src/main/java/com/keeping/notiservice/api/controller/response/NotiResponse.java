package com.keeping.notiservice.api.controller.response;

import com.keeping.notiservice.domain.noti.Type;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotiResponse {
    
    private Long notiId;

    private String title;

    private String content;

    private Type type;

    private LocalDateTime createdDate;


    @Builder
    public NotiResponse(Long notiId, String title, String content, Type type, LocalDateTime createdDate) {
        this.notiId = notiId;
        this.title = title;
        this.content = content;
        this.type = type;
        this.createdDate = createdDate;
    }
}
