package com.keeping.bankservice.api.controller.feign_client.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class MemberKeyResponse {

    private String childKey;
    private String parentKey;


    @Builder
    private MemberKeyResponse(String childKey, String parentKey) {
        this.childKey = childKey;
        this.parentKey = parentKey;
    }
}
