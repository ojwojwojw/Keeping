package com.keeping.missionservice.api.controller.mission.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class RelationshipCheckRequest {
    
    private String parentKey;
    
    private String childKey;

    @Builder
    public RelationshipCheckRequest(String parentKey, String childKey) {
        this.parentKey = parentKey;
        this.childKey = childKey;
    }
}
