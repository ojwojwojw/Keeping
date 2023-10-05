package com.keeping.bankservice.domain.regular_allowance;

import com.keeping.bankservice.domain.account.Account;
import com.keeping.bankservice.global.common.TimeBaseEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@NoArgsConstructor(access = PROTECTED)
public class RegularAllowance extends TimeBaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "regular_allowance_id")
    private Long id;

    @Column(name = "parent_key", nullable = false)
    private String parentKey;

    @Column(name = "child_key", nullable = false)
    private String childKey;

    @Column(nullable = false)
    private int money;

    @Column(nullable = false)
    private int day;


    @Builder
    private RegularAllowance(Long id, String parentKey, String childKey, int money, int day) {
        this.id = id;
        this.parentKey = parentKey;
        this.childKey = childKey;
        this.money = money;
        this.day = day;
    }

    public static RegularAllowance toRegularAllowance(String parentKey, String childKey, int money, int day) {
        return RegularAllowance.builder()
                .parentKey(parentKey)
                .childKey(childKey)
                .money(money)
                .day(day)
                .build();
    }
}
