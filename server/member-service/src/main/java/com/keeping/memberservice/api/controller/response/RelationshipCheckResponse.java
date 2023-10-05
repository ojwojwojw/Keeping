package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

@Data
public class RelationshipCheckResponse {

    private boolean isParentialRelationship;

    @Builder
    private RelationshipCheckResponse(boolean isParentialRelationship) {
        this.isParentialRelationship = isParentialRelationship;
    }
}
