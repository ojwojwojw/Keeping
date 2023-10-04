package com.keeping.questionservice.domain.repository;

import com.keeping.questionservice.api.controller.response.QuestionResponse;
import com.keeping.questionservice.api.controller.response.TodayQuestionResponse;
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

    public Optional<QuestionResponse> findByChildKeyAndSceduledTime(String memberKey, LocalDate scheduledTime) {
        return Optional.ofNullable(queryFactory
                .select(constructor(QuestionResponse.class,
                        question.id,
                        question.childKey,
                        question.content,
                        question.parentAnswer,
                        question.childAnswer,
                        question.isCreated,
                        question.createdDate))
                .from(question)
                .where(question.childKey.eq(memberKey),
                        question.scheduledTime.between(scheduledTime.plusDays(1).atStartOfDay(), scheduledTime.plusDays(2).atStartOfDay()))
                .fetchOne());
    }

    public List<TodayQuestionResponse> findByChildKeyAndSceduledTimeAtNow(String memberKey, LocalDate scheduledTime) {
        return queryFactory
                .select(constructor(TodayQuestionResponse.class,
                        question.id,
                        question.childKey,
                        question.content,
                        question.parentAnswer,
                        question.childAnswer,
                        question.isCreated,
                        question.createdDate))
                .from(question)
                .where(question.childKey.eq(memberKey)
                                .or(question.parentKey.eq(memberKey)),
                        question.scheduledTime.between(scheduledTime.atStartOfDay(), scheduledTime.plusDays(1).atStartOfDay()))
                .fetch();
    }
    
    public List<QuestionResponse> getQuestionByMemberKey(String memberKey) {
        return queryFactory
                .select(constructor(QuestionResponse.class,
                        question.id,
                        question.childKey,
                        question.content,
                        question.parentAnswer,
                        question.childAnswer,
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
                        question.childKey,
                        question.content,
                        question.parentAnswer,
                        question.childAnswer,
                        question.isCreated,
                        question.createdDate))
                .from(question)
                .where(question.parentKey.eq(memberKey)
                        .or(question.childKey.eq(memberKey)),
                        question.id.eq(questionId))
                .fetchOne());
    }
}
