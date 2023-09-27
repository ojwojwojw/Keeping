package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

@Data
public class ChildKeyResponse {

    private String childKey;

    @Builder
    private ChildKeyResponse(String childKey) {
        this.childKey = childKey;
    }
}
