package com.keeping.bankservice.domain.piggy;

import com.keeping.bankservice.global.common.TimeBaseEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

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

    @Column(name = "account_number", nullable = false)
    private String accountNumber;

    @Column(nullable = false)
    private String content;

    @Column(name = "goal_money", nullable = false)
    private Long goalMoney;

    @Column(name = "auth_password", nullable = false)
    private String authPassword;

    @Column(nullable = false)
    private Long balance;

    @Column(name = "upload_image", nullable = false)
    private String uploadImage;

    @Enumerated(STRING)
    @Column(nullable = false)
    private Completed completed;

    private boolean active;


//    @Builder
//    private Piggy() {
//
//    }

}
