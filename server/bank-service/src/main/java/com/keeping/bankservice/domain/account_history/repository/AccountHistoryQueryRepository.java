package com.keeping.bankservice.domain.account_history.repository;

import com.keeping.bankservice.api.service.account_history.dto.ShowAccountHistoryDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.List;

import static com.keeping.bankservice.domain.account_history.QAccountHistory.accountHistory;

@Repository
public class AccountHistoryQueryRepository {

    private final JPAQueryFactory queryFactory;

    public AccountHistoryQueryRepository(EntityManager em) { this.queryFactory = new JPAQueryFactory(em); }

    public List<ShowAccountHistoryDto> showAccountHistories(String memberKey, String accountNumber) {
        List<ShowAccountHistoryDto> result = queryFactory
                .select(Projections.fields(ShowAccountHistoryDto.class,
                        accountHistory.id,
                        accountHistory.account,
                        accountHistory.storeName,
                        accountHistory.type,
                        accountHistory.money,
                        accountHistory.balance,
                        accountHistory.remain,
                        accountHistory.largeCategory,
                        accountHistory.detailed,
                        accountHistory.address,
                        accountHistory.latitude,
                        accountHistory.longitude))
                .from(accountHistory)
                .where(accountHistory.account.accountNumber.eq(accountNumber), accountHistory.account.memberKey.eq(memberKey))
                .orderBy(accountHistory.createdDate.desc())
                .fetch();

        return result;
    }

    public List<ShowAccountHistoryDto> showAccountDailyHistories(String memberKey, String accountNumber, LocalDateTime startDateTime, LocalDateTime endDateTime) {
        List<ShowAccountHistoryDto> result = queryFactory
                .select(Projections.fields(ShowAccountHistoryDto.class,
                        accountHistory.id,
                        accountHistory.account,
                        accountHistory.storeName,
                        accountHistory.type,
                        accountHistory.money,
                        accountHistory.balance,
                        accountHistory.remain,
                        accountHistory.largeCategory,
                        accountHistory.detailed,
                        accountHistory.address,
                        accountHistory.latitude,
                        accountHistory.longitude))
                .from(accountHistory)
                .where(accountHistory.account.accountNumber.eq(accountNumber), accountHistory.account.memberKey.eq(memberKey), accountHistory.createdDate.between(startDateTime, endDateTime))
                .orderBy(accountHistory.createdDate.desc())
                .fetch();

        return result;
    }
}
