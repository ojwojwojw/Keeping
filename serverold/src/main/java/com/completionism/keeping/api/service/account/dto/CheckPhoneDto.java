package com.completionism.keeping.api.service.account.dto;

import com.completionism.keeping.api.controller.account.request.CheckPhoneRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class CheckPhoneDto {

    private String phone;


    @Builder
    private CheckPhoneDto(String phone) {
        this.phone = phone;
    }

    public static CheckPhoneDto toDto(CheckPhoneRequest request) {
        return CheckPhoneDto.builder()
                .phone(makeUserPhone(request.getPhone()))
                .build();
    }

    private static String makeUserPhone(String phoneString) {
        String[] phone = phoneString.split("-");

        return phone[0] + phone[1] + phone[2];
    }
}
