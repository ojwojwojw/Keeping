package com.keeping.bankservice.domain.piggy_history.repository;

import com.keeping.bankservice.api.controller.piggy_history.response.ShowPiggyHistoryResponse;
import com.keeping.bankservice.domain.piggy.Piggy;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;

import java.util.List;

import static com.keeping.bankservice.domain.piggy_history.QPiggyHistory.piggyHistory;

@Repository
public class PiggyHistoryQueryRepository {

    private final JPAQueryFactory queryFactory;

    public PiggyHistoryQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    public String lastSavingHistoryName(Piggy piggy) {
        String result = queryFactory
                .select(piggyHistory.name)
                .from(piggyHistory)
                .where(piggyHistory.piggy.eq(piggy))
                .orderBy(piggyHistory.createdDate.desc())
                .limit(1)
                .fetchFirst();

        return result;
    }

    public List<ShowPiggyHistoryResponse> showPiggyHistory(Long piggyId) {
        List<ShowPiggyHistoryResponse> result = queryFactory
                .select(Projections.fields(ShowPiggyHistoryResponse.class,
                        piggyHistory.id,
                        piggyHistory.name,
                        piggyHistory.money,
                        piggyHistory.balance))
                .from(piggyHistory)
                .where(piggyHistory.piggy.id.eq(piggyId))
                .orderBy(piggyHistory.createdDate.desc())
                .fetch();

        return result;
    }
}
