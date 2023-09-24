package com.keeping.bankservice.api.service.online.dto;

import com.keeping.bankservice.api.controller.online.request.ApproveOnlineRequest;
import com.keeping.bankservice.global.common.Approve;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class ApproveOnlineDto {

    private Long onlineId;
    private String childKey;
    private Approve approve;
    private String comment;


    @Builder
    private ApproveOnlineDto(Long onlineId, String childKey, Approve approve, String comment) {
        this.onlineId = onlineId;
        this.childKey = childKey;
        this.approve = approve;
        this.comment = comment;
    }

    public static ApproveOnlineDto toDto(ApproveOnlineRequest request) {
        return ApproveOnlineDto.builder()
                .onlineId(request.getOnlineId())
                .childKey(request.getChildKey())
                .approve(Approve.valueOf(request.getApprove()))
                .comment(request.getComment())
                .build();
    }

}
