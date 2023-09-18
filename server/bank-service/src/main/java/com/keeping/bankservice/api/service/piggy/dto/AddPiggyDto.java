package com.keeping.bankservice.api.service.piggy.dto;

import com.keeping.bankservice.api.controller.piggy.request.AddPiggyRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddPiggyDto {

    private String content;
    private int goalMoney;
    private String authPassword;
    private MultipartFile uploadImage;


    @Builder
    private AddPiggyDto(String content, int goalMoney, String authPassword, MultipartFile uploadImage) {
        this.content = content;
        this.goalMoney = goalMoney;
        this.authPassword = authPassword;
        this.uploadImage = uploadImage;
    }

    public static AddPiggyDto toDto(AddPiggyRequest request) {
        return AddPiggyDto.builder()
                .content(request.getContent())
                .goalMoney(request.getGoalMoney())
                .authPassword(request.getAuthPassword())
                .uploadImage(request.getUploadImage())
                .build();
    }
}
