package com.completionism.keeping.domain.mission.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;

@Repository
public class MissionQueryRepository {
    
    private final JPAQueryFactory queryFactory;
    
    public MissionQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }
    
    
}
