package com.keeping.bankservice.domain.piggy;

import com.keeping.bankservice.global.common.TimeBaseEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

import static com.keeping.bankservice.domain.piggy.Completed.INCOMPLETED;
import static javax.persistence.EnumType.STRING;
import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@NoArgsConstructor(access = PROTECTED)
public class Piggy extends TimeBaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "piggy_id")
    private Long id;

    @Column(name = "child_key", nullable = false)
    private String childKey;

    @Column(name = "account_number", unique = true, nullable = false)
    private String accountNumber;

    @Column(nullable = false)
    private String content;

    @Column(name = "goal_money", nullable = false)
    private int goalMoney;

    @Column(name = "auth_password", nullable = false)
    private String authPassword;

    @Column(nullable = false)
    private int balance;

    @Column(name = "upload_image", nullable = false)
    private String uploadImage;

    @Column(name = "saved_image", nullable = false)
    private String savedImage;

    @Enumerated(STRING)
    @Column(nullable = false)
    private Completed completed;

    private boolean active;


    @Builder
    private Piggy(Long id, String childKey, String accountNumber, String content, int goalMoney, String authPassword, int balance, String uploadImage, String savedImage, Completed completed, boolean active) {
        this.id = id;
        this.childKey = childKey;
        this.accountNumber = accountNumber;
        this.content = content;
        this.goalMoney = goalMoney;
        this.authPassword = authPassword;
        this.balance = balance;
        this.uploadImage = uploadImage;
        this.savedImage = savedImage;
        this.completed = completed;
        this.active = active;
    }

    public static Piggy toPiggy(String childKey, String accountNumber, String content, int goalMoney, String authPassword, String uploadImage, String savedImage) {
        return Piggy.builder()
                .childKey(childKey)
                .accountNumber(accountNumber)
                .content(content)
                .goalMoney(goalMoney)
                .authPassword(authPassword)
                .balance(0)
                .uploadImage(uploadImage)
                .savedImage(savedImage)
                .completed(INCOMPLETED)
                .active(true)
                .build();
    }

    public void updateBalance(int money) {
        this.balance += money;
    }
}
