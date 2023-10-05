package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

@Data
public class LinkResponse {
    private String childKey;
    private String parentKey;

    @Builder
    public LinkResponse(String childKey, String parentKey) {
        this.childKey = childKey;
        this.parentKey = parentKey;
    }
}
