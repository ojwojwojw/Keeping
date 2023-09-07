package com.completionism.keeping.api.service.mission.dto;

import com.completionism.keeping.api.controller.mission.request.AddMissionRequest;
import com.completionism.keeping.domain.mission.Completed;
import com.completionism.keeping.domain.mission.MissionType;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;

@Data
public class AddMissionDto {

    private String todo;

    private int money;

    private MissionType type;

    private LocalDate startDate;

    private LocalDate endDate;

    private Completed completed;
    
    @Builder
    public AddMissionDto(String todo, int money, MissionType type, LocalDate startDate, LocalDate endDate, Completed completed) {
        this.todo = todo;
        this.money = money;
        this.type = type;
        this.startDate = startDate;
        this.endDate = endDate;
        this.completed = completed;
    }

    public static AddMissionDto toDto(AddMissionRequest request) {
        return AddMissionDto.builder()
                .todo(request.getTodo())
                .money(request.getMoney())
                .type(request.getType())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .completed(request.getCompleted())
                .build();
    }
}
