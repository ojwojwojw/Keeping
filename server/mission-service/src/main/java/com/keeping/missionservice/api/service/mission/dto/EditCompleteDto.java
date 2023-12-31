package com.keeping.missionservice.api.service.mission.dto;

import com.keeping.missionservice.api.controller.mission.request.EditCompleteRequest;
import com.keeping.missionservice.domain.mission.Completed;
import com.keeping.missionservice.domain.mission.MemberType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class EditCompleteDto {

    private MemberType type;
    private Long missionId;
    private String cheeringMessage;
    private Completed completed;


    @Builder
    public EditCompleteDto(MemberType type, Long missionId, String cheeringMessage, Completed completed) {
        this.type = type;
        this.missionId = missionId;
        this.cheeringMessage = cheeringMessage;
        this.completed = completed;
    }

    public static EditCompleteDto toDto(EditCompleteRequest request) {
        return EditCompleteDto.builder()
                .type(request.getType())
                .missionId(request.getMissionId())
                .cheeringMessage(request.getCheeringMessage())
                .completed(request.getCompleted())
                .build();
    }
}
