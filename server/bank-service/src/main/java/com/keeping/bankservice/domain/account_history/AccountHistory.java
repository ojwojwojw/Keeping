package com.keeping.bankservice.domain.account_history;

import com.keeping.bankservice.domain.account.Account;
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
public class AccountHistory extends TimeBaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "account_history_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @Column(name = "store_name", nullable = false)
    private String storeName;

    @Column(nullable = false)
    private boolean type;

    @Column(nullable = false)
    private Long money;

    @Column(nullable = false)
    private Long balance;

    @Column(nullable = false)
    private Long remain;

    @Enumerated(STRING)
    @Column(nullable = false)
    @ColumnDefault("'ETC'")
    private Category category;

    @Column(nullable = false)
    private boolean detailed;

    @Column(nullable = false)
    private String address;

    @Column()
    private Double latitude;

    @Column
    private Double longitude;


    @Builder
    private AccountHistory(Long id, Account account, String storeName, boolean type, Long money, Long balance, Long remain, Category category, boolean detailed, String address, Double latitude, Double longitude) {
        this.id = id;
        this.account = account;
        this.storeName = storeName;
        this.type = type;
        this.money = money;
        this.balance = balance;
        this.remain = remain;
        this.category = category;
        this.detailed = detailed;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public static AccountHistory toAccountHistory(Account account, String storeName, boolean type, Long money, Long balance, Long remain, Category category, boolean detailed, String address, Double latitude, Double longitude) {
        return AccountHistory.builder()
                .account(account)
                .storeName(storeName)
                .type(type)
                .money(money)
                .balance(balance)
                .remain(remain)
                .category(category)
                .detailed(detailed)
                .address(address)
                .latitude(latitude)
                .longitude(longitude)
                .build();
    }
}
