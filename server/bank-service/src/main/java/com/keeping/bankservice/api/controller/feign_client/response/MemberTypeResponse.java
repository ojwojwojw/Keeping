package com.keeping.bankservice.api.controller.feign_client.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class MemberTypeResponse {

    private boolean isTypeRight;

    @Builder
    private MemberTypeResponse(boolean isTypeRight) {
        this.isTypeRight = isTypeRight;
    }
}
