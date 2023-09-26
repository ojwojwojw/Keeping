package com.keeping.memberservice.api.service.member.dto;

import lombok.Builder;
import lombok.Data;

@Data
public class LinkResultDto {

    private boolean success;
    private String failMessage;

    private String partner;
    private String relation;
    private int expire;

    @Builder
    private LinkResultDto(boolean success, String failMessage, String partner, String relation, int expire) {
        this.success = success;
        this.failMessage = failMessage;
        this.partner = partner;
        this.relation = relation;
        this.expire = expire;
    }
}
