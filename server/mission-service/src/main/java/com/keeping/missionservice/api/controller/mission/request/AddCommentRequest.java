package com.keeping.missionservice.api.controller.mission.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@NoArgsConstructor
public class AddCommentRequest {

    @NotNull
    private String memberKey;

    @NotNull
    private Long missionId;

    @NotNull
    private String comment;

    @Builder
    public AddCommentRequest(String memberKey, Long missionId, String comment) {
        this.memberKey = memberKey;
        this.missionId = missionId;
        this.comment = comment;
    }
}
