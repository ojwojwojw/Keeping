package com.keeping.bankservice.api.controller.piggy.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddPiggyRequest {

    @NotBlank
    private String content;

    @NotBlank
    private int goalMoney;

    @NotBlank
    @Size(min = 6, max = 6)
    private String authPassword;

    @NotBlank
    private MultipartFile uploadImage;


    @Builder
    private AddPiggyRequest(String content, int goalMoney, String authPassword, MultipartFile uploadImage) {
        this.content = content;
        this.goalMoney = goalMoney;
        this.authPassword = authPassword;
        this.uploadImage = uploadImage;
    }

    public static AddPiggyRequest toRequest(String content, int goalMoney, String authPassword, MultipartFile uploadImage) {
        return AddPiggyRequest.builder()
                .content(content)
                .goalMoney(goalMoney)
                .authPassword(authPassword)
                .uploadImage(uploadImage)
                .build();
    }
}
