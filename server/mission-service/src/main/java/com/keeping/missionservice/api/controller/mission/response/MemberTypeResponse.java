package com.keeping.missionservice.api.controller.mission.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberTypeResponse {

    private boolean isTypeRight;

    @Builder
    public MemberTypeResponse(boolean isTypeRight) {
        this.isTypeRight = isTypeRight;
    }
}
