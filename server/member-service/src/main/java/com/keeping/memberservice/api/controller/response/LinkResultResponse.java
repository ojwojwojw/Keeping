package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

@Data
public class LinkResultResponse {

    private String partner;
    private String relation;
    private int expire;

    @Builder
    private LinkResultResponse(String partner, String relation, int expire) {
        this.partner = partner;
        this.relation = relation;
        this.expire = expire;
    }
}
