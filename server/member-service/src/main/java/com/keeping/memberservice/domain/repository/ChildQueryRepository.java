package com.keeping.memberservice.domain.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

import static com.keeping.memberservice.domain.QChild.child;

@Repository
public class ChildQueryRepository {

    private final JPAQueryFactory queryFactory;

    public ChildQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    public List<String> getAllChildKey() {
        return queryFactory.select(child.member.memberKey)
                .from(child)
                .fetch();
    }
}
