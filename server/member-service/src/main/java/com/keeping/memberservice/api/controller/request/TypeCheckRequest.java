package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

@Data
public class TypeCheckRequest {

    private String memberKey;
    private String type;

    @Builder
    public TypeCheckRequest(String memberKey, String type) {
        this.memberKey = memberKey;
        this.type = type;
    }
}
