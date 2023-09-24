package com.keeping.bankservice.api.service.allowance.dto;

import com.keeping.bankservice.api.controller.allowance.request.ApproveAllowanceRequest;
import com.keeping.bankservice.global.common.Approve;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class ApproveAllowanceDto {

    private Long allowanceId;
    private String childKey;
    private Approve approve;


    @Builder()
    private ApproveAllowanceDto(Long allowanceId, String childKey, Approve approve) {
        this.allowanceId = allowanceId;
        this.childKey = childKey;
        this.approve = approve;
    }

    public static ApproveAllowanceDto toDto(ApproveAllowanceRequest request) {
        return ApproveAllowanceDto.builder()
                .allowanceId(request.getAllowanceId())
                .childKey(request.getChildKey())
                .approve(Approve.valueOf(request.getApprove()))
                .build();
    }
}
