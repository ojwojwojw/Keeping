package com.keeping.notiservice.domain.noti.repository;

import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.domain.noti.Type;
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

    public List<NotiResponse> findByMemberKey(String memberKey) {
        return queryFactory
                .select(constructor(NotiResponse.class,
                        noti.id,
                        noti.title,
                        noti.content,
                        noti.type))
                .from(noti)
                .where(noti.memberKey.eq(memberKey))
                .fetch();
    }


    public List<NotiResponse> findByMemberKeyAndType(String memberKey, Type type) {
        return queryFactory
                .select(constructor(NotiResponse.class,
                        noti.id,
                        noti.title,
                        noti.content,
                        noti.type))
                .from(noti)
                .where(noti.memberKey.eq(memberKey),
                        noti.type.eq(type))
                .fetch();
    }
    
}
