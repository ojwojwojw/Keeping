package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

@Data
public class LinkcodeResponse {

    private String linkcode;
    private int expire;

    @Builder
    public LinkcodeResponse(String linkcode, int expire) {
        this.linkcode = linkcode;
        this.expire = expire;
    }
}
