package com.completionism.keeping.api.controller.mission.request;


import com.completionism.keeping.domain.mission.Completed;
import com.completionism.keeping.domain.mission.MissionType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
public class AddMissionRequest {

    private String todo;

    private int money;

    private MissionType type;

    private LocalDate startDate;

    private LocalDate endDate;

    private Completed completed;

    @Builder
    public AddMissionRequest(String todo, int money, MissionType type, LocalDate startDate, LocalDate endDate, Completed completed) {
        this.todo = todo;
        this.money = money;
        this.type = type;
        this.startDate = startDate;
        this.endDate = endDate;
        this.completed = completed;
    }
}
