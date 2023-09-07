package com.completionism.keeping.domain.mission;

import com.completionism.keeping.global.common.TimeBaseEntity;
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
    
    // TODO: 자녀 연관관계
    
    @Column
    private String todo;
    
    @Column
    private int money;
    
    @Column
    private String parentComment;
    
    @Column
    private String childComment;
    
    @Column
    private MissionType type;
    
    @Column
    private LocalDate startDate;
    
    @Column
    private LocalDate endDate;
    
    @Column
    private Completed completed;

    @Builder
    public Mission(Long id, String todo, int money, String parentComment, String childComment, MissionType type, LocalDate startDate, LocalDate endDate, Completed completed) {
        this.id = id;
        this.todo = todo;
        this.money = money;
        this.parentComment = parentComment;
        this.childComment = childComment;
        this.type = type;
        this.startDate = startDate;
        this.endDate = endDate;
        this.completed = completed;
    }

    public static Mission toMission(String todo, int money, MissionType type, LocalDate startDate, LocalDate endDate, Completed completed) {
        return Mission.builder()
                .todo(todo)
                .money(money)
                .type(type)
                .startDate(startDate)
                .endDate(endDate)
                .completed(completed)
                .build();
    }
    
}
