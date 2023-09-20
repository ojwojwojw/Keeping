package com.keeping.missionservice.api.service.mission.dto;

import com.keeping.missionservice.api.controller.mission.request.AddCommentRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AddCommentDto {

    private String memberKey;

    private Long missionId;

    private String comment;

    @Builder
    public AddCommentDto(String memberKey, Long missionId, String comment) {
        this.memberKey = memberKey;
        this.missionId = missionId;
        this.comment = comment;
    }

    public static AddCommentDto toDto(AddCommentRequest request) {
        return AddCommentDto.builder()
                .memberKey(request.getMemberKey())
                .missionId(request.getMissionId())
                .comment(request.getComment())
                .build();
    }
}
