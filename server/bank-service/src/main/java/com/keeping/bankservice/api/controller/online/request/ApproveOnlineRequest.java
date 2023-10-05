package com.keeping.bankservice.api.controller.online.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class ApproveOnlineRequest {

    @NotNull
    private Long onlineId;

    @NotBlank
    private String childKey;

    @NotBlank
    private String approve;

    @NotBlank
    private String comment;


    @Builder
    private ApproveOnlineRequest(Long onlineId, String  childKey, String approve, String comment) {
        this.onlineId = onlineId;
        this.childKey = childKey;
        this.approve = approve;
        this.comment = comment;
    }
}
