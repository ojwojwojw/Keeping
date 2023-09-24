package com.keeping.bankservice.api.controller.allowance.response;

import com.keeping.bankservice.domain.allowance.Approve;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ShowAllowanceResponse {

    private Long id;
    private String content;
    private int money;
    private Approve approve;


    @Builder
    public ShowAllowanceResponse(Long id, String content, int money, Approve approve) {
        this.id = id;
        this.content = content;
        this.money = money;
        this.approve = approve;
    }
}