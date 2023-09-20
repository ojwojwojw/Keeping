package com.keeping.missionservice.domain.mission.repository;

import com.keeping.missionservice.api.controller.mission.response.MissionResponse;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

import static com.keeping.missionservice.domain.mission.QMission.mission;
import static com.querydsl.core.types.Projections.constructor;

@Repository
public class MissionQueryRepository {
    
    private final JPAQueryFactory queryFactory;
    
    public MissionQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }
    
    public List<MissionResponse> showMission(String childKey) {
        return queryFactory.select(constructor(MissionResponse.class,
                        mission.childKey,
                        mission.id,
                        mission.todo,
                        mission.money,
                        mission.cheeringMessage,
                        mission.childComment,
                        mission.startDate,
                        mission.endDate,
                        mission.completed,
                        mission.createdDate))
                .from(mission)
                .where(mission.childKey.eq(childKey))
                .fetch();
    }

    public Optional<MissionResponse> showDetailMission(String childKey, Long missionId) {
        return Optional.ofNullable(queryFactory.select(constructor(MissionResponse.class,
                        mission.childKey,
                        mission.id,
                        mission.todo,
                        mission.money,
                        mission.cheeringMessage,
                        mission.childComment,
                        mission.startDate,
                        mission.endDate,
                        mission.completed,
                        mission.createdDate))
                .from(mission)
                .where(mission.childKey.eq(childKey),
                        mission.id.eq(missionId))
                .fetchOne());
    }
}
