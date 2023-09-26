package com.keeping.questionservice.domain.repository;

import com.keeping.questionservice.api.controller.response.QuestionResponse;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static com.keeping.questionservice.domain.QQuestion.question;
import static com.querydsl.core.types.Projections.constructor;

@Repository
public class QuestionQueryRepository {
    
    private final JPAQueryFactory queryFactory;

    public QuestionQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    public Optional<QuestionResponse> findByChildKeyAndCreatedDate(String childKey, LocalDate createdDate) {
        return Optional.ofNullable(queryFactory
                .select(constructor(QuestionResponse.class,
                        question.id,
                        question.content,
                        question.parentAnswer,
                        question.childKey,
                        question.isCreated,
                        question.createdDate))
                .from(question)
                .where(question.childKey.eq(childKey),
                        question.createdDate.between(createdDate.plusDays(1).atStartOfDay(), createdDate.plusDays(2).atStartOfDay()))
                .fetchOne());
    }

    public Optional<QuestionResponse> findByChildKeyAndCreatedDateAtNow(String childKey, LocalDate createdDate) {
        return Optional.ofNullable(queryFactory
                .select(constructor(QuestionResponse.class,
                        question.id,
                        question.content,
                        question.parentAnswer,
                        question.childKey,
                        question.isCreated,
                        question.createdDate))
                .from(question)
                .where(question.childKey.eq(childKey),
                        question.createdDate.between(createdDate.atStartOfDay(), createdDate.plusDays(1).atStartOfDay()))
                .fetchOne());
    }
    
    public List<QuestionResponse> getQuestionByMemberKey(String memberKey) {
        return queryFactory
                .select(constructor(QuestionResponse.class,
                        question.id,
                        question.content,
                        question.parentAnswer,
                        question.childKey,
                        question.isCreated,
                        question.createdDate))
                .from(question)
                .where(question.parentKey.eq(memberKey)
                        .or(question.childKey.eq(memberKey)))
                .fetch();
    }

    public Optional<QuestionResponse> getQuetsionByMemberKeyAndId(String memberKey, Long questionId) {
        return Optional.ofNullable(queryFactory
                .select(constructor(QuestionResponse.class,
                        question.id,
                        question.content,
                        question.parentAnswer,
                        question.childKey,
                        question.isCreated,
                        question.createdDate))
                .from(question)
                .where(question.parentKey.eq(memberKey)
                        .or(question.childKey.eq(memberKey)),
                        question.id.eq(questionId))
                .fetchOne());
    }
}
