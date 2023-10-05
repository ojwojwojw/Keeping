package com.keeping.memberservice.api.service.member.dto;

import com.keeping.memberservice.domain.Member;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AddMemberDto {

    private String loginId;
    private String loginPw;
    private String memberKey;
    private String name;
    private String phone;
    private String birth;

    @Builder
    public AddMemberDto(String loginId, String loginPw, String memberKey, String name, String phone, String birth) {
        this.loginId = loginId;
        this.loginPw = loginPw;
        this.memberKey = memberKey;
        this.name = name;
        this.phone = phone;
        this.birth = birth;
    }

    public Member toEntity(String encryptionPw) {
        String[] birth = this.birth.split("-");
        return Member.builder()
                .loginId(this.loginId)
                .encryptionPw(encryptionPw)
                .memberKey(this.memberKey)
                .name(this.name)
                .phone(this.phone)
                .birth(LocalDateTime.of(Integer.parseInt(birth[0]), Integer.parseInt(birth[1]), Integer.parseInt(birth[2]), 0, 0))
                .active(true)
                .build();
    }
}
