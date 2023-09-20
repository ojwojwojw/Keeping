package com.keeping.missionservice.api.controller.mission.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberRelationshipRequest {
    
    private String parentKey;
    
    private String childKey;

    @Builder
    public MemberRelationshipRequest(String parentKey, String childKey) {
        this.parentKey = parentKey;
        this.childKey = childKey;
    }
}
