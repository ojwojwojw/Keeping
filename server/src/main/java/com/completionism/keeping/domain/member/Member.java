package com.completionism.keeping.domain.member;

import com.completionism.keeping.global.common.TimeBaseEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import javax.validation.constraints.Size;

import java.time.LocalDateTime;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@NoArgsConstructor(access = PROTECTED)
public class Member extends TimeBaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long id;

    @Column(nullable = false, length = 20)
    @Size(max = 20, min = 5)
    private String loginId;

    @Column(nullable = false)
    private String encryptionPw;

    @Column(nullable = false, length = 20)
    @Size(max = 20, min = 1)
    private String name;

    @Column(nullable = false, length = 13)
    @Size(max = 13, min = 13)
    private String phone;
    private LocalDateTime birth;
    private String profileImage;
    @Column(nullable = true)
    private String fcmToken;
    private boolean active;

    @Builder
    private Member(Long id, String loginId, String encryptionPw, String name, String phone, LocalDateTime birth, String profileImage, String fcmToken, boolean active) {
        this.id = id;
        this.loginId = loginId;
        this.encryptionPw = encryptionPw;
        this.name = name;
        this.phone = phone;
        this.birth = birth;
        this.profileImage = profileImage;
        this.fcmToken = fcmToken;
        this.active = active;
    }
}
