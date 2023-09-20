package com.keeping.bankservice.domain.account_history.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;

@Repository
public class AccountHistoryQueryRepository {

    private final JPAQueryFactory queryFactory;

    public AccountHistoryQueryRepository(EntityManager em) { this.queryFactory = new JPAQueryFactory(em); }
}
