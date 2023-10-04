package com.keeping.missionservice.api.controller.mission.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class SendNotiRequest {

    private String memberKey;

    private String title;

    private String content;

    private String type;

    @Builder
    public SendNotiRequest(String memberKey, String title, String content, String type) {
        this.memberKey = memberKey;
        this.title = title;
        this.content = content;
        this.type = type;
    }
}
