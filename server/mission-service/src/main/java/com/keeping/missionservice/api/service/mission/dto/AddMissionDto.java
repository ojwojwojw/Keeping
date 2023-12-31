package com.keeping.missionservice.api.service.mission.dto;

import com.keeping.missionservice.api.controller.mission.request.AddMissionRequest;
import com.keeping.missionservice.domain.mission.MissionType;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;

@Data
public class AddMissionDto {

    private MissionType type; // 부모가 아이에게, 아이가 부모에게

    private String to; // 어떤 사람한테 보내야하는지

    private String todo; // 미션 내용

    private int money; // 미션 보상금

    private String cheeringMessage; // 부모의 응원 메시지
    
    private String childRequestComment; // 자녀의 요청 메시지

    private LocalDate startDate; // 미션 시작일

    private LocalDate endDate; // 미션 마감일

    
    @Builder
    public AddMissionDto(MissionType type, String to, String todo, int money, String cheeringMessage, String childRequestComment, LocalDate startDate, LocalDate endDate) {
        this.type = type;
        this.to = to;
        this.todo = todo;
        this.money = money;
        this.cheeringMessage = cheeringMessage;
        this.childRequestComment = childRequestComment;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // Dto 객체로 변환
    public static AddMissionDto toDto(AddMissionRequest request) {
        return AddMissionDto.builder()
                .type(MissionType.valueOf(request.getType()))
                .to(request.getTo())
                .todo(request.getTodo())
                .money(request.getMoney())
                .cheeringMessage(request.getCheeringMessage())
                .childRequestComment(request.getChildRequestComment())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .build();
    }

}
