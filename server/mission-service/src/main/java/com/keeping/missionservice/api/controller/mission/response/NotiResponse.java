package com.keeping.missionservice.api.controller.mission.response;


import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class NotiResponse {

    boolean isNotiSend;

    @Builder
    public NotiResponse(boolean isNotiSend) {
        this.isNotiSend = isNotiSend;
    }
}
