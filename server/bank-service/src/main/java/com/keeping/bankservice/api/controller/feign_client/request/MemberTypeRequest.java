package com.keeping.bankservice.api.controller.feign_client.request;

import com.keeping.bankservice.global.common.MemberType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class MemberTypeRequest {

    private String memberKey;
    private MemberType type;


    @Builder
    private MemberTypeRequest(String memberKey, MemberType type) {
        this.memberKey = memberKey;
        this.type = type;
    }
}
