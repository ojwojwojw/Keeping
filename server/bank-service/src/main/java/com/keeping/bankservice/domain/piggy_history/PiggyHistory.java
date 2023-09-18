package com.keeping.bankservice.domain.piggy_history;

import com.keeping.bankservice.domain.piggy.Piggy;
import com.keeping.bankservice.global.common.TimeBaseEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@NoArgsConstructor(access = PROTECTED)
public class PiggyHistory extends TimeBaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "piggy_history_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name="piggy_id", nullable = false)
    private Piggy piggy;

    @Column
    private String name;

    @Column
    private int money;

    @Column
    private int balance;


    @Builder
    private PiggyHistory(Long id, Piggy piggy, String name, int money, int balance) {
        this.id = id;
        this.piggy = piggy;
        this.name = name;
        this.money = money;
        this.balance = balance;
    }

    public static PiggyHistory toPiggyHistory(Piggy piggy, String name, int money, int balance) {
        return PiggyHistory.builder()
                .piggy(piggy)
                .name(name)
                .money(money)
                .balance(balance)
                .build();
    }
}
