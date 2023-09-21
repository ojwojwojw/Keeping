package com.keeping.notiservice.domain.noti.repository;

import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

import static com.keeping.notiservice.domain.noti.QNoti.noti;
import static com.querydsl.core.types.Projections.constructor;

@Repository
public class NotiQueryRepository {
    
    private final JPAQueryFactory queryFactory;

    public NotiQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    public List<NotiResponse> showNoti(String memberKey) {
        return queryFactory
                .select(constructor(NotiResponse.class,
                        noti.id,
                        noti.receptionKey,
                        noti.sentKey,
                        noti.title,
                        noti.content,
                        noti.type))
                .from(noti)
                .where(noti.sentKey.eq(memberKey))
                .fetch();
    }
    
}
