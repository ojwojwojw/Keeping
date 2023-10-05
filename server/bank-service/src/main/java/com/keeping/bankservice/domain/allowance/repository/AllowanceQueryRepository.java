package com.keeping.bankservice.domain.allowance.repository;

import com.keeping.bankservice.api.controller.allowance.response.ShowAllowanceResponse;
import com.keeping.bankservice.global.common.Approve;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.List;

import static com.keeping.bankservice.domain.allowance.QAllowance.allowance;

@Repository
public class AllowanceQueryRepository {

    private final JPAQueryFactory queryFactory;

    public AllowanceQueryRepository(EntityManager em) { this.queryFactory = new JPAQueryFactory(em); }

    public List<ShowAllowanceResponse> showAllowances(String memberKey) {
        List<ShowAllowanceResponse> result = queryFactory
                .select(Projections.fields(ShowAllowanceResponse.class,
                        allowance.id,
                        allowance.content,
                        allowance.money,
                        allowance.approve,
                        allowance.createdDate))
                .from(allowance)
                .where(allowance.childKey.eq(memberKey))
                .orderBy(allowance.createdDate.desc())
                .fetch();

        return result;
    }

    public List<ShowAllowanceResponse> showTypeAllowances(String memberKey, Approve approve) {
        List<ShowAllowanceResponse> result = queryFactory
                .select(Projections.fields(ShowAllowanceResponse.class,
                        allowance.id,
                        allowance.content,
                        allowance.money,
                        allowance.approve,
                        allowance.createdDate))
                .from(allowance)
                .where(allowance.childKey.eq(memberKey), allowance.approve.eq(approve))
                .orderBy(allowance.createdDate.desc())
                .fetch();

        return result;
    }

    public int countMonthAllowance(String memberKey, LocalDateTime startDateTime, LocalDateTime endDateTime) {
        int result = Math.toIntExact(queryFactory
                .select(allowance.count())
                .from(allowance)
                .where(allowance.childKey.eq(memberKey), allowance.createdDate.between(startDateTime, endDateTime))
                .fetchFirst());

        return result;
    }
}
