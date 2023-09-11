//package com.keeping.bankservice.domain.account;
//
//import com.completionism.keeping.domain.member.Member;
//import com.completionism.keeping.global.common.TimeBaseEntity;
//import lombok.Builder;
//import lombok.Getter;
//import lombok.NoArgsConstructor;
//
//import javax.persistence.*;
//import javax.validation.constraints.Size;
//
//@Entity
//@Getter
//@NoArgsConstructor
//public class Account extends TimeBaseEntity {
//
//    @Id
//    @GeneratedValue
//    @Column(name = "account_id")
//    private Long id;
//
//    @ManyToOne
//    @JoinColumn(name = "member_id", nullable = false)
//    private Member member;
//
//    @Column(name = "account_number", unique = true, nullable = false)
//    @Size(min = 18, max = 18)
//    private String accountNumber;
//
//    @Column(name = "auth_password", nullable = false)
//    @Size(min = 6, max = 6)
//    private String authPassword;
//
//    @Column(nullable = false)
//    private Long balance;
//
//    @Column(nullable = false)
//    private boolean active;
//
//
//    @Builder
//    public Account(Long id, Member member, String accountNumber, String authPassword, Long balance, boolean active) {
//        this.id = id;
//        this.member = member;
//        this.accountNumber = accountNumber;
//        this.authPassword = authPassword;
//        this.balance = balance;
//        this.active = active;
//    }
//
//    public static Account toAccount(Member member, String accountNumber, String authPassword, Long balance, boolean active) {
//        return Account.builder()
//                .member(member)
//                .accountNumber(accountNumber)
//                .authPassword(authPassword)
//                .balance(balance)
//                .active(active)
//                .build();
//    }
//
//}
