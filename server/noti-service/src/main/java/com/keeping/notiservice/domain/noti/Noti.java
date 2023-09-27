package com.keeping.notiservice.domain.noti;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@RequiredArgsConstructor
public class Noti extends TimeBaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "noti_id")
    private Long id;
    
    @Column(nullable = false, length = 255)
    private String memberKey;
    
    @Column(nullable = false, length = 255)
    private String fcmToken;
    
    @Column(nullable = false)
    private String title;
    
    @Column(nullable = false)
    private String content;
    
    @Column(nullable = false)
    private Type type;

    @Builder
    public Noti(Long id, String memberKey, String fcmToken, String title, String content, Type type) {
        this.id = id;
        this.memberKey = memberKey;
        this.fcmToken = fcmToken;
        this.title = title;
        this.content = content;
        this.type = type;
    }

    public static Noti toNoti(String memberKey, String fcmToken, String title, String content, Type type) {
        return Noti.builder()
                .memberKey(memberKey)
                .fcmToken(fcmToken)
                .title(title)
                .content(content)
                .type(type)
                .build();
    }
}
