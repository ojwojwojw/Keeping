package com.keeping.questionservice.domain.repository;

import com.keeping.questionservice.api.controller.response.CommentResponse;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

import static com.keeping.questionservice.domain.QComment.comment;
import static com.querydsl.core.types.Projections.constructor;

@Repository
public class CommentQueryRepository {

    private final JPAQueryFactory queryFactory;

    public CommentQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    public List<CommentResponse> findByIdAndActive(String memberKey, boolean isActive) {
        return queryFactory
                .select(constructor(CommentResponse.class,
                        comment.id,
                        comment.memberKey,
                        comment.content,
                        comment.createdDate))
                .from(comment)
                .where(comment.memberKey.eq(memberKey),
                        comment.isActive.eq(isActive))
                .fetch();
    }
}
