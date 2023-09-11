//package com.keeping.bankservice.api.service.account.dto;
//
//import com.completionism.keeping.api.controller.account.request.AddAccountRequest;
//import lombok.Builder;
//import lombok.Data;
//import lombok.NoArgsConstructor;
//
//@Data
//@NoArgsConstructor
//public class AddAccountDto {
//
//    private String authPassword;
//
//
//    @Builder
//    public AddAccountDto(String authPassword) {
//        this.authPassword = authPassword;
//    }
//
//    public static AddAccountDto toDto(AddAccountRequest request) {
//        return AddAccountDto.builder()
//                .authPassword(request.getAuthPassword())
//                .build();
//    }
//}
