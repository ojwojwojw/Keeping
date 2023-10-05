package com.keeping.missionservice.api.controller.mission.request;

import lombok.Builder;
import lombok.Data;
import org.hibernate.validator.constraints.Range;

import javax.validation.constraints.*;
import java.time.LocalDate;

@Data
public class EditMissionRequest {
    @NotNull
    private Long missionId;

    @NotBlank
    @Size(min = 0)
    private String todo; // 미션 내용

    @NotNull
    @Positive
    @Range(min = 10)
    private int money; // 미션 보상금

    private String cheeringMessage; // 부모 응원 메시지

    private LocalDate startDate; // 미션 시작일

    private LocalDate endDate; // 미션 마감일

    @Builder
    public EditMissionRequest(Long missionId, String todo, int money, String cheeringMessage, LocalDate startDate, LocalDate endDate) {
        this.missionId = missionId;
        this.todo = todo;
        this.money = money;
        this.cheeringMessage = cheeringMessage;
        this.startDate = startDate;
        this.endDate = endDate;
    }
}
