package com.keeping.notiservice.api.controller.response;

import com.keeping.notiservice.domain.noti.Type;
import lombok.Builder;
import lombok.Data;

@Data
public class NotiResponse {
    
    private Long notiId;
    
    private String receptionkey;

    private String sentKey;

    private String title;

    private String content;

    private Type type;

    @Builder
    public NotiResponse(Long notiId, String receptionkey, String sentKey, String title, String content, Type type) {
        this.notiId = notiId;
        this.receptionkey = receptionkey;
        this.sentKey = sentKey;
        this.title = title;
        this.content = content;
        this.type = type;
    }
}
