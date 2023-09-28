package com.keeping.missionservice.domain.mission.repository;

import com.keeping.missionservice.api.controller.mission.response.MissionResponse;
import com.keeping.missionservice.domain.mission.Completed;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.Arrays;
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

    public Optional<Integer> countMoney(String childKey) {
        List<Completed> completeds = Arrays.asList(Completed.YET, Completed.CREATE_WAIT, Completed.FINISH_WAIT);
        return Optional.ofNullable(queryFactory
                .select(mission.money.sum())
                .from(mission)
                .where(mission.childKey.eq(childKey),
                        mission.completed.in(completeds))
                .groupBy(mission.childKey)
                .fetchOne());

    }

    public List<MissionResponse> showMission(String childKey) {
        return queryFactory.select(constructor(MissionResponse.class,
                        mission.childKey,
                        mission.id,
                        mission.type,
                        mission.todo,
                        mission.money,
                        mission.cheeringMessage,
                        mission.childRequestComment,
                        mission.finishedComment,
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
                        mission.type,
                        mission.todo,
                        mission.money,
                        mission.cheeringMessage,
                        mission.childRequestComment,
                        mission.finishedComment,
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
