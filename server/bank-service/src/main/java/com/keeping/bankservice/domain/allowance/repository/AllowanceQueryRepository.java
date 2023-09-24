package com.keeping.bankservice.domain.allowance.repository;

import com.keeping.bankservice.api.controller.allowance.response.ShowAllowanceResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
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
                        allowance.approve))
                .from(allowance)
                .where(allowance.childKey.eq(memberKey))
                .orderBy(allowance.createdDate.desc())
                .fetch();

        return result;
    }

}
