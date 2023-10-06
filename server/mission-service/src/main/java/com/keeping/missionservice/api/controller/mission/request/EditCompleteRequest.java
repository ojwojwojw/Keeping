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

    @NotNull
    private MemberType type;
    
    @NotNull
    private Long missionId;

    @NotNull
    private String cheeringMessage;

    @NotNull
    private Completed completed;

    @Builder
    public EditCompleteRequest(MemberType type, Long missionId, String cheeringMessage, Completed completed) {
        this.type = type;
        this.missionId = missionId;
        this.cheeringMessage = cheeringMessage;
        this.completed = completed;
    }
}
