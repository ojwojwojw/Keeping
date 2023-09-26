package com.keeping.missionservice.api.controller.mission.request;

import com.keeping.missionservice.domain.mission.MemberType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberTypeRequest {

    private MemberType type;

    @Builder
    public MemberTypeRequest(MemberType type) {
        this.type = type;
    }
}
