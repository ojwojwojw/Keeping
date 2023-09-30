package com.keeping.memberservice.domain.repository;

import com.keeping.memberservice.api.controller.response.ChildrenResponse;
import com.keeping.memberservice.domain.Parent;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

//import static com.keeping.memberservice.domain.QLink.*;
import static com.keeping.memberservice.domain.QLink.link;
import static com.querydsl.core.types.Projections.constructor;

@Repository
public class LinkQueryRepository {
    private final JPAQueryFactory queryFactory;

    public LinkQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    public List<ChildrenResponse> getChildList(Parent parent) {
        return queryFactory.select(constructor(ChildrenResponse.class,
                        link.child.member.memberKey,
                        link.child.member.name,
                        link.child.member.profileImage
                ))
                .from(link)
                .where(link.parent.eq(parent))
                .fetch();
    }
}