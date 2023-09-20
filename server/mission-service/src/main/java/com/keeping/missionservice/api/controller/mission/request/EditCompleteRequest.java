package com.keeping.missionservice.api.controller.mission.request;

import com.keeping.missionservice.domain.mission.Completed;
import com.keeping.missionservice.domain.mission.MemberType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
@NoArgsConstructor
public class EditCompleteRequest {
    
    @NotBlank
    private String memberKey;

    @NotNull
    private MemberType type;
    
    @NotNull
    private Long missionId;

    @NotBlank
    private Completed completed;

    @Builder
    public EditCompleteRequest(String memberKey, MemberType type, Long missionId, Completed completed) {
        this.memberKey = memberKey;
        this.type = type;
        this.missionId = missionId;
        this.completed = completed;
    }
}
