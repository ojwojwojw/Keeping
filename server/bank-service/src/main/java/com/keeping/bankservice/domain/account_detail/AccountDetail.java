package com.keeping.bankservice.domain.account_detail;

import com.keeping.bankservice.domain.account_history.AccountHistory;
import com.keeping.bankservice.global.common.TimeBaseEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.*;

import static javax.persistence.EnumType.STRING;
import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@NoArgsConstructor(access = PROTECTED)
public class AccountDetail extends TimeBaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "account_detail_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "account_history_id", nullable = false)
    private AccountHistory accountHistory;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private Long money;

    @Enumerated(STRING)
    @Column(name = "small_category", nullable = false)
    @ColumnDefault("'ETC'")
    private SmallCategory smallCategory;


    @Builder
    private AccountDetail(Long id, AccountHistory accountHistory, String content, Long money, SmallCategory smallCategory) {
        this.id = id;
        this.accountHistory = accountHistory;
        this.content = content;
        this.money = money;
        this.smallCategory = smallCategory;
    }

    public static AccountDetail toAccountDetail(AccountHistory accountHistory, String content, Long money, SmallCategory smallCategory) {
        return AccountDetail.builder()
                .accountHistory(accountHistory)
                .content(content)
                .money(money)
                .smallCategory(smallCategory)
                .build();
    }


}
