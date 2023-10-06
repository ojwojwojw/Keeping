package com.keeping.missionservice.api.service.mission.dto;

import com.keeping.missionservice.api.controller.mission.request.AddCommentRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AddCommentDto {

    private Long missionId;

    private String comment;

    @Builder
    public AddCommentDto(Long missionId, String comment) {
        this.missionId = missionId;
        this.comment = comment;
    }

    public static AddCommentDto toDto(AddCommentRequest request) {
        return AddCommentDto.builder()
                .missionId(request.getMissionId())
                .comment(request.getComment())
                .build();
    }
}
