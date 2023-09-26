package com.keeping.bankservice.domain.account.repository;

import com.keeping.bankservice.api.controller.account.response.ShowAccountResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;

import static com.keeping.bankservice.domain.account.QAccount.account;

@Repository
public class AccountQueryRepository {
    private final JPAQueryFactory queryFactory;

    public AccountQueryRepository(EntityManager em) { this.queryFactory = new JPAQueryFactory(em); }

    public ShowAccountResponse showAccount(String memberKey) {
        ShowAccountResponse result = queryFactory
                .select(Projections.fields(ShowAccountResponse.class,
                        account.id,
                        account.accountNumber,
                        account.balance,
                        account.createdDate))
                .from(account)
                .where(account.memberKey.eq(memberKey), account.active.isTrue())
                .fetchOne();

        return result;
    }
}
