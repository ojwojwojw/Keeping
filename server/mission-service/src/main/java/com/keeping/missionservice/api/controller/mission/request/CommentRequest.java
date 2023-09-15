package com.keeping.missionservice.api.controller.mission.request;

import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
public class CommentRequest {
    
    @NotBlank
    private String memberKey;
    
    @NotNull
    private Long missionId;
    
    @NotBlank
    private String comment;

    @Builder
    public CommentRequest(String memberKey, Long missionId, String comment) {
        this.memberKey = memberKey;
        this.missionId = missionId;
        this.comment = comment;
    }
}
