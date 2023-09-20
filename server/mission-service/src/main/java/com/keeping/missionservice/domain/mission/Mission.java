package com.keeping.missionservice.domain.mission;

import com.keeping.missionservice.global.common.TimeBaseEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter
@RequiredArgsConstructor
public class Mission extends TimeBaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "mission_id")
    private Long id;
    
    @Column(name = "child_key")
    private String childKey;

    @Column
    private MissionType type;
    
    @Column
    private String todo;
    
    @Column
    private int money;
    
    @Column
    private String cheeringMessage;
    
    @Column
    private String childComment;
    
    @Column
    private LocalDate startDate;
    
    @Column
    private LocalDate endDate;
    
    @Column
    private Completed completed;

    @Builder
    public Mission(Long id, String childKey, MissionType type, String todo, int money, String cheeringMessage, String childComment, LocalDate startDate, LocalDate endDate, Completed completed) {
        this.id = id;
        this.childKey = childKey;
        this.type = type;
        this.todo = todo;
        this.money = money;
        this.cheeringMessage = cheeringMessage;
        this.childComment = childComment;
        this.startDate = startDate;
        this.endDate = endDate;
        this.completed = completed;
    }
    
    
    public static Mission toMission(String childKey, MissionType type, String todo, int money, String cheeringMessage, LocalDate startDate, LocalDate endDate, Completed completed) {
        return Mission.builder()
                .childKey(childKey)
                .type(type)
                .todo(todo)
                .money(money)
                .cheeringMessage(cheeringMessage)
                .startDate(startDate)
                .endDate(endDate)
                .completed(completed)
                .build();
    }
    
}
