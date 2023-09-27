package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Data
public class RelationshipCheckRequest {

    @NotBlank
    private String parentKey;
    @NotBlank
    private String childKey;

    @Builder
    public RelationshipCheckRequest(String parentKey, String childKey) {
        this.parentKey = parentKey;
        this.childKey = childKey;
    }
}
