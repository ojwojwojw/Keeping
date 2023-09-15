package com.keeping.missionservice.api.controller.mission.request;

import com.keeping.missionservice.domain.mission.Completed;
import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
public class EditCompleteRequest {
    
    @NotBlank
    private String memberKey;
    
    @NotNull
    private Long missionId;

    @NotBlank
    private Completed completed;

    @Builder
    public EditCompleteRequest(String memberKey, Long missionId, Completed completed) {
        this.memberKey = memberKey;
        this.missionId = missionId;
        this.completed = completed;
    }
}
