package com.completionism.keeping.domain.piggy.repository;

import com.completionism.keeping.api.service.piggy.dto.ShowPiggyDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

import static com.completionism.keeping.domain.piggy.QPiggy.piggy;

@Repository
public class PiggyQueryRepository {

    private final JPAQueryFactory queryFactory;

    public PiggyQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    public List<ShowPiggyDto> showPiggy(String memberKey) {
        List<ShowPiggyDto> result = queryFactory
                .select(Projections.fields(ShowPiggyDto.class,
                        piggy.id,
                        piggy.childKey,
                        piggy.accountNumber,
                        piggy.content,
                        piggy.goalMoney,
                        piggy.balance,
                        piggy.savedImage,
                        piggy.completed))
                .from(piggy)
                .where(piggy.childKey.eq(memberKey))
                .fetch();

        return result;
    }
}
