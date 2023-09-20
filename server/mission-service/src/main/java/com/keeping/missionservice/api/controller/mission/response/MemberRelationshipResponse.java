package com.keeping.missionservice.api.controller.mission.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberRelationshipResponse {
    boolean isParentialRelationship;

    @Builder
    public MemberRelationshipResponse(boolean isParentialRelationship) {
        this.isParentialRelationship = isParentialRelationship;
    }
}
