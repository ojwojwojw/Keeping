package com.keeping.bankservice.api.service.account_detail.dto;

import com.keeping.bankservice.api.controller.account_detail.request.AccountDetailRequest;
import com.keeping.bankservice.domain.account_detail.SmallCategory;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

import static lombok.AccessLevel.PROTECTED;

@Data
@NoArgsConstructor(access = PROTECTED)
public class AddAccountDetailDto {

    private Long accountHistoryId;
    private String content;
    private Long money;
    private SmallCategory smallCategory;


    @Builder
    private AddAccountDetailDto(Long accountHistoryId, String content, Long money, SmallCategory smallCategory) {
        this.accountHistoryId = accountHistoryId;
        this.content = content;
        this.money = money;
        this.smallCategory = smallCategory;
    }

    public static AddAccountDetailDto toDto(AccountDetailRequest request) {
        return AddAccountDetailDto.builder()
                .accountHistoryId(request.getAccountHistoryId())
                .content(request.getContent())
                .money(request.getMoney())
                .smallCategory(request.getSmallCategory() == null? null: SmallCategory.valueOf(request.getSmallCategory()))
                .build();
    }

    public static List<AddAccountDetailDto> toDtoList(List<AccountDetailRequest> request) {
        List<AddAccountDetailDto> result = new ArrayList<AddAccountDetailDto>();

        for(AccountDetailRequest accountDetailRequest: request) {
            result.add(toDto(accountDetailRequest));
        }

        return result;
    }
}
