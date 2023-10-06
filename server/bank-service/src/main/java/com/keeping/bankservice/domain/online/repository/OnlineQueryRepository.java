package com.keeping.bankservice.domain.online.repository;

import com.keeping.bankservice.api.controller.online.response.ShowOnlineResponse;
import com.keeping.bankservice.global.common.Approve;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

import static com.keeping.bankservice.domain.online.QOnline.online;

@Repository
public class OnlineQueryRepository {

    private final JPAQueryFactory queryFactory;

    public OnlineQueryRepository(EntityManager em) { this.queryFactory = new JPAQueryFactory(em); }

    public List<ShowOnlineResponse> showOnlines(String memberKey) {
        List<ShowOnlineResponse> result = queryFactory
                .select(Projections.fields(ShowOnlineResponse.class,
                        online.id,
                        online.productName,
                        online.url,
                        online.content,
                        online.totalMoney,
                        online.childMoney,
                        online.comment,
                        online.approve,
                        online.createdDate))
                .from(online)
                .where(online.childKey.eq(memberKey))
                .orderBy(online.createdDate.desc())
                .fetch();

        return result;
    }

    public List<ShowOnlineResponse> showTypeOnlines(String memberKey, Approve approve) {
        List<ShowOnlineResponse> result = queryFactory
                .select(Projections.fields(ShowOnlineResponse.class,
                        online.id,
                        online.productName,
                        online.url,
                        online.content,
                        online.totalMoney,
                        online.childMoney,
                        online.comment,
                        online.approve,
                        online.createdDate))
                .from(online)
                .where(online.childKey.eq(memberKey), online.approve.eq(approve))
                .orderBy(online.createdDate.desc())
                .fetch();

        return result;
    }
}
