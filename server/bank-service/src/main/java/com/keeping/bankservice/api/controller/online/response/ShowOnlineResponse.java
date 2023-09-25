package com.keeping.bankservice.api.controller.online.response;

import com.keeping.bankservice.global.common.Approve;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class ShowOnlineResponse {

    private Long id;
    private String productName;
    private String url;
    private String content;
    private int totalMoney;
    private int childMoney;
    private String comment;
    private Approve approve;
    private LocalDateTime createdDate;


    @Builder
    public ShowOnlineResponse(Long id, String productName, String url, String content, int totalMoney, int childMoney, String comment, Approve approve, LocalDateTime createdDate) {
        this.id = id;
        this.productName = productName;
        this.url = url;
        this.content = content;
        this.totalMoney = totalMoney;
        this.childMoney = childMoney;
        this.comment = comment;
        this.approve = approve;
        this.createdDate = createdDate;
    }
}
