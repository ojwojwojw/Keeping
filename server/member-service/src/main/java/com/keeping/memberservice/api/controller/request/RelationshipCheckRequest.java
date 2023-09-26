package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

@Data
public class RelationshipCheckRequest {

    private String parentKey;
    private String childKey;

    @Builder
    public RelationshipCheckRequest(String parentKey, String childKey) {
        this.parentKey = parentKey;
        this.childKey = childKey;
    }
}
