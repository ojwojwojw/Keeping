package com.keeping.notiservice.api.controller.request;

import com.keeping.notiservice.domain.noti.Type;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class SendNotiRequest {
    private String memberKey;
    
    private String title;

    private String content;

    private Type type;

    @Builder
    public SendNotiRequest(String memberKey, String title, String content, Type type) {
        this.memberKey = memberKey;
        this.title = title;
        this.content = content;
        this.type = type;
    }
}
