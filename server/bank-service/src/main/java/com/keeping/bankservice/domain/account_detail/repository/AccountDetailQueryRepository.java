package com.keeping.bankservice.domain.account_detail.repository;

import com.keeping.bankservice.api.service.account_detail.dto.ShowAccountDetailDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

import static com.keeping.bankservice.domain.account_detail.QAccountDetail.accountDetail;

@Repository
public class AccountDetailQueryRepository {

    private final JPAQueryFactory queryFactory;

    public AccountDetailQueryRepository(EntityManager em) { this.queryFactory = new JPAQueryFactory(em); }

    public List<ShowAccountDetailDto> showAccountDetailes(Long accountHistoryId, String memberKey) {
        List<ShowAccountDetailDto> result = queryFactory
                .select(Projections.fields(ShowAccountDetailDto.class,
                        accountDetail.id,
                        accountDetail.content,
                        accountDetail.money,
                        accountDetail.smallCategory))
                .from(accountDetail)
                .where(accountDetail.accountHistory.id.eq(accountHistoryId), accountDetail.accountHistory.account.memberKey.eq(memberKey))
                .orderBy(accountDetail.createdDate.desc())
                .fetch();

        return result;
    }

}
