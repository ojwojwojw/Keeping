package com.keeping.notiservice.api.controller.response;

import com.keeping.notiservice.domain.noti.Type;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotiResponse {

    private Long id;

    private String receptionkey;

    private String sentKey;

    private String title;

    private String content;

    private Type type;

    private LocalDateTime createdDate;


    @Builder
    public NotiResponse(Long id, String receptionkey, String sentKey, String title, String content, Type type, LocalDateTime createdDate) {
        this.id = id;
        this.receptionkey = receptionkey;
        this.sentKey = sentKey;
        this.title = title;
        this.content = content;
        this.type = type;
        this.createdDate = createdDate;
    }
}
