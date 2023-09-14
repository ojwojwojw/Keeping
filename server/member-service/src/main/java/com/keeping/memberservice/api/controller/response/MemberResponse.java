package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

@Data
public class MemberResponse {

    private String loginId;
    private String name;
    private String phone;
    private String birth;

    @Builder
    private MemberResponse(String loginId, String name, String phone, String birth) {
        this.loginId = loginId;
        this.name = name;
        this.phone = phone;
        this.birth = birth;
    }
}
