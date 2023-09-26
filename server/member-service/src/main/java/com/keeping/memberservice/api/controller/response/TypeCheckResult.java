package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

@Data
public class TypeCheckResult {

    private boolean isTypeRight;

    @Builder
    private TypeCheckResult(boolean isTypeRight) {
        this.isTypeRight = isTypeRight;
    }
}
