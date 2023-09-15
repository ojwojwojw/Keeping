package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.Column;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;

@Data
public class JoinParentRequest {

    @NotBlank
    @Size(min = 5, max = 20)
    @Pattern(regexp = "^[a-z0-9]*$")
    private String loginId;
    @NotBlank
    @Size(min = 5, max = 25)
    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$")
    private String loginPw;
    @NotBlank
    @Size(max = 20, min = 1)
    private String name;
    @Column(nullable = false, length = 13)
    @Size(max = 13, min = 13)
    @Pattern(regexp = "^\\d{3}-\\d{3,4}-\\d{4}$")
    private String phone;
    @NotBlank
    @Size(min = 10, max = 10)
    private String birth;

    @Builder
    private JoinParentRequest(String loginId, String loginPw, String name, String phone, String birth) {
        this.loginId = loginId;
        this.loginPw = loginPw;
        this.name = name;
        this.phone = phone;
        this.birth = birth;
    }
}
