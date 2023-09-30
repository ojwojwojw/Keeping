package com.keeping.bankservice.api.controller.account_history.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class ShowChildHistoryResponse {

    private String parentMemberKey;
    private String childMemberKey;
    private List<ShowAccountHistoryResponse> transactionList;


    @Builder
    private ShowChildHistoryResponse(String parentMemberKey, String childMemberKey, List<ShowAccountHistoryResponse> transactionList) {
        this.parentMemberKey = parentMemberKey;
        this.childMemberKey = childMemberKey;
        this.transactionList = transactionList;
    }

    public static ShowChildHistoryResponse toResponse(String parentMemberKey, String childMemberKey, List<ShowAccountHistoryResponse> transactionList) {
        return ShowChildHistoryResponse.builder()
                .parentMemberKey(parentMemberKey)
                .childMemberKey(childMemberKey)
                .transactionList(transactionList)
                .build();
    }
}
