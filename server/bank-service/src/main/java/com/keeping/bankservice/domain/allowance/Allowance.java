package com.keeping.bankservice.domain.allowance;

import com.keeping.bankservice.global.common.Approve;
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
public class Allowance extends TimeBaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "allowance_id")
    private Long id;

    @Column(name = "child_key", nullable = false)
    private String childKey;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private int money;

    @Enumerated(STRING)
    @Column(nullable = false)
    private Approve approve;


    @Builder
    private Allowance(Long id, String childKey, String content, int money, Approve approve) {
        this.id = id;
        this.childKey = childKey;
        this.content = content;
        this.money = money;
        this.approve = approve;
    }

    public static Allowance toAllowance(String childKey, String content, int money, Approve approve) {
        return Allowance.builder()
                .content(childKey)
                .content(content)
                .money(money)
                .approve(approve)
                .build();
    }

    public void updateApproveStatus(Approve approve) {
        this.approve = approve;
    }
}

