package com.keeping.bankservice.domain.online;

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
public class Online extends TimeBaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "online_id")
    private Long id;

    @Column(name = "child_key", nullable = false)
    private String childKey;

    @Column(name = "product_name", nullable = false)
    private String productName;

    @Column(nullable = false)
    private String url;

    @Column(nullable = false)
    private String content;

    @Column(name = "total_money", nullable = false)
    private int totalMoney;

    @Column(name = "child_money", nullable = false)
    private int childMoney;

    @Column()
    private String comment;

    @Enumerated(STRING)
    @Column(nullable = false)
    private Approve approve;


    @Builder
    private Online(Long id, String childKey, String productName, String url, String content, int totalMoney, int childMoney, String comment, Approve approve) {
        this.id = id;
        this.childKey = childKey;
        this.productName = productName;
        this.url = url;
        this.content = content;
        this.totalMoney = totalMoney;
        this.childMoney = childMoney;
        this.comment = comment;
        this.approve = approve;
    }

    public static Online toOnline(String childKey, String productName, String url, String content, int totalMoney, int childMoney, String comment, Approve approve) {
        return Online.builder()
                .childKey(childKey)
                .productName(productName)
                .url(url)
                .content(content)
                .totalMoney(totalMoney)
                .childMoney(childMoney)
                .comment(comment)
                .approve(approve)
                .build();
    }
}
