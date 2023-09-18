package com.keeping.memberservice.api.controller.request;

import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Data
public class UpdateLoginPwRequest {

    @NotBlank
    private String type;
    @NotBlank
    @Size(min = 5, max = 25)
    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$")
    private String newLoginPw;
    @NotBlank
    private String oldLoginPw;

    @Builder
    private UpdateLoginPwRequest(String type, String newLoginPw, String oldLoginPw) {
        this.type = type;
        this.newLoginPw = newLoginPw;
        this.oldLoginPw = oldLoginPw;
    }
}
