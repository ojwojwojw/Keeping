package com.keeping.bankservice.domain.online.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;

@Repository
public class OnlineQueryRepository {

    private final JPAQueryFactory queryFactory;

    public OnlineQueryRepository(EntityManager em) { this.queryFactory = new JPAQueryFactory(em); }

}
