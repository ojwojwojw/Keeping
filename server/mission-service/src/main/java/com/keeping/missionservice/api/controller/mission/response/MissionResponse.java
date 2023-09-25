package com.keeping.missionservice.api.controller.mission.response;

import com.keeping.missionservice.domain.mission.Completed;
import com.keeping.missionservice.domain.mission.MissionType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class MissionResponse {

    private String childKey;

    private Long id;

    private MissionType type;

    private String todo;

    private int money;

    private String cheeringMessage;

    private String childComment;

    private LocalDate startDate;

    private LocalDate endDate;

    private Completed completed;

    private LocalDateTime createdDate;

    @Builder
    public MissionResponse(String childKey, Long id, MissionType type, String todo, int money, String cheeringMessage, String childComment, LocalDate startDate, LocalDate endDate, Completed completed, LocalDateTime createdDate) {
        this.childKey = childKey;
        this.id = id;
        this.type = type;
        this.todo = todo;
        this.money = money;
        this.cheeringMessage = cheeringMessage;
        this.childComment = childComment;
        this.startDate = startDate;
        this.endDate = endDate;
        this.completed = completed;
        this.createdDate = createdDate;
    }
}
