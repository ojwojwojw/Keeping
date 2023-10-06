package com.keeping.bankservice.domain.account_history.repository;

import com.keeping.bankservice.api.service.account_history.dto.ShowAccountHistoryDto;
import com.keeping.bankservice.domain.account.Account;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import javax.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.List;

import static com.keeping.bankservice.domain.account_history.QAccountHistory.accountHistory;

@Repository
public class AccountHistoryQueryRepository {

    private final JPAQueryFactory queryFactory;

    public AccountHistoryQueryRepository(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    public List<ShowAccountHistoryDto> showAccountHistories(String memberKey, String accountNumber) {
        List<ShowAccountHistoryDto> result = queryFactory
                .select(Projections.fields(ShowAccountHistoryDto.class,
                        accountHistory.id,
//                        accountHistory.account,
                        accountHistory.storeName,
                        accountHistory.type,
                        accountHistory.money,
                        accountHistory.balance,
                        accountHistory.remain,
                        accountHistory.largeCategory,
                        accountHistory.detailed,
                        accountHistory.address,
                        accountHistory.latitude,
                        accountHistory.longitude,
                        accountHistory.createdDate))
                .from(accountHistory)
                .where(accountHistory.account.accountNumber.eq(accountNumber), accountHistory.account.memberKey.eq(memberKey))
                .orderBy(accountHistory.createdDate.desc())
                .fetch();

        return result;
    }

    public List<ShowAccountHistoryDto> showAccountDailyHistories(String memberKey, String accountNumber, LocalDateTime startDateTime, LocalDateTime endDateTime, String type) {
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
                        accountHistory.longitude,
                        accountHistory.createdDate))
                .from(accountHistory)
                .where(whatAccountNumber(accountNumber), accountHistory.account.memberKey.eq(memberKey), whatType(type), accountHistory.createdDate.between(startDateTime, endDateTime))
                .orderBy(accountHistory.createdDate.desc())
                .fetch();

        return result;
    }

    public Long countMonthExpense(Account account, LocalDateTime startDateTime, LocalDateTime endDateTime) {
        Long result = queryFactory
                .select(accountHistory.money.sum())
                .from(accountHistory)
                .where(accountHistory.account.eq(account), accountHistory.type.isFalse(), accountHistory.createdDate.between(startDateTime, endDateTime))
                .fetchOne();

        return result;
    }

    private BooleanExpression whatAccountNumber(String accountNumber) {
        if(StringUtils.hasText(accountNumber)) {
            return accountHistory.account.accountNumber.eq(accountNumber);
        }
        return null;
    }

    private BooleanExpression whatType(String type) {
        if (type.equals("DEPOSIT")) {
            return accountHistory.type.isTrue();
        } else if (type.equals("WITHDRAW")) {
            return accountHistory.type.isFalse();
        }

        return null;
    }
}
