package com.keeping.bankservice.api.controller.allowance.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class ApproveAllowanceRequest {

    @NotNull
    private Long allowanceId;

    @NotBlank
    private String childKey;

    @NotBlank
    private String approve;


    @Builder
    private ApproveAllowanceRequest(Long allowanceId, String childKey, String approve) {
        this.allowanceId = allowanceId;
        this.childKey = childKey;
        this.approve = approve;
    }
}
