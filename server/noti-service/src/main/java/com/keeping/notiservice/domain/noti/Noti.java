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
    private String receptionKey;
    
    @Column(nullable = false, length = 255)
    private String sentKey;
    
    @Column(nullable = false)
    private String title;
    
    @Column(nullable = false)
    private String content;
    
    @Column(nullable = false)
    private Type type;

    @Builder
    public Noti(Long id, String receptionKey, String sentKey, String title, String content, Type type) {
        this.id = id;
        this.receptionKey = receptionKey;
        this.sentKey = sentKey;
        this.title = title;
        this.content = content;
        this.type = type;
    }

    public static Noti toNoti(String receptionKey, String sentKey, String title, String content, Type type) {
        return Noti.builder()
                .receptionKey(receptionKey)
                .sentKey(sentKey)
                .title(title)
                .content(content)
                .type(type)
                .build();
    }
}
