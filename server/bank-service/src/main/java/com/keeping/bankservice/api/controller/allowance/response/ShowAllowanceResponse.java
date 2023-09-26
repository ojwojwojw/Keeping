package com.keeping.bankservice.api.controller.allowance.response;

import com.keeping.bankservice.global.common.Approve;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class ShowAllowanceResponse {

    private Long id;
    private String content;
    private int money;
    private Approve approve;
    private LocalDateTime createdDate;


    @Builder
    public ShowAllowanceResponse(Long id, String content, int money, Approve approve, LocalDateTime createdDate) {
        this.id = id;
        this.content = content;
        this.money = money;
        this.approve = approve;
        this.createdDate = createdDate;
    }
}