package com.keeping.missionservice.api.controller.mission.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class SendNotiRequest {

    private String memberKey;

    private String title;

    private String body;

    @Builder
    public SendNotiRequest(String memberKey, String title, String body) {
        this.memberKey = memberKey;
        this.title = title;
        this.body = body;
    }
}
