package com.keeping.bankservice.domain.account;

import com.keeping.bankservice.global.common.TimeBaseEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import javax.validation.constraints.Size;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@NoArgsConstructor(access = PROTECTED)
public class Account extends TimeBaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "account_id")
    private Long id;

    @Column(name = "member_key", nullable = false)
    private String memberKey;

    @Column(name = "account_number", unique = true, nullable = false)
    @Size(min = 16, max = 18)
    private String accountNumber;

    @Column(name = "auth_password", nullable = false)
    private String authPassword;

    @Column(nullable = false)
    private Long balance;

    @Column(nullable = false)
    private boolean active;


    @Builder
    private Account(Long id, String memberKey, String accountNumber, String authPassword, Long balance, boolean active) {
        this.id = id;
        this.memberKey = memberKey;
        this.accountNumber = accountNumber;
        this.authPassword = authPassword;
        this.balance = balance;
        this.active = active;
    }

    public static Account toAccount(String memberKey, String accountNumber, String authPassword) {
        return Account.builder()
                .memberKey(memberKey)
                .accountNumber(accountNumber)
                .authPassword(authPassword)
                .balance(0l)
                .active(true)
                .build();
    }

    public void updateBalance(int money, boolean plus) {
        if(plus) {
            this.balance += money;
        }
        else {
            this.balance -= money;
        }
    }

}
