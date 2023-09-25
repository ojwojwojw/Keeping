package com.keeping.bankservice.api.service.account_detail.dto;

import com.keeping.bankservice.domain.account_detail.SmallCategory;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ShowAccountDetailDto {

    private Long id;
    private String content;
    private Long money;
    private SmallCategory smallCategory;


    @Builder
    public ShowAccountDetailDto(Long id, String content, Long money, SmallCategory smallCategory) {
        this.id = id;
        this.content = content;
        this.money = money;
        this.smallCategory = smallCategory;
    }

    public static ShowAccountDetailDto toDto(Long id, String content, Long money, SmallCategory smallCategory) {
        return ShowAccountDetailDto.builder()
                .id(id)
                .content(content)
                .money(money)
                .smallCategory(smallCategory)
                .build();
    }
}
