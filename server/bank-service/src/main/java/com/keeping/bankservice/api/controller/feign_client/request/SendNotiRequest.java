package com.keeping.bankservice.api.controller.feign_client.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class SendNotiRequest {

    private String memberKey;
    private String title;
    private String content;
    private String type;


    @Builder
    private SendNotiRequest(String memberKey, String title, String content, String type) {
        this.memberKey = memberKey;
        this.title = title;
        this.content = content;
        this.type = type;
    }
}
