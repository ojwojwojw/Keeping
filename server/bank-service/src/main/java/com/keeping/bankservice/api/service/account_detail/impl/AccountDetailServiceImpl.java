package com.keeping.bankservice.api.service.account_detail.impl;

import com.keeping.bankservice.api.service.account_detail.AccountDetailService;
import com.keeping.bankservice.api.service.account_detail.dto.AddAccountDetailDto;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountDetailValidationDto;
import com.keeping.bankservice.domain.account_detail.AccountDetail;
import com.keeping.bankservice.domain.account_detail.SmallCategory;
import com.keeping.bankservice.domain.account_detail.repository.AccountDetailRepository;
import com.keeping.bankservice.domain.account_history.AccountHistory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class AccountDetailServiceImpl implements AccountDetailService {

    private final AccountHistoryService accountHistoryService;
    private final AccountDetailRepository accountDetailRepository;

    @Override
    public void addAccountDetail(String memberKey, List<AddAccountDetailDto> dtoList) {
        for(AddAccountDetailDto dto: dtoList) {
            // 연결된 거래 내역 검증 -> remain, detailed 컬럼 값 갱신
            AddAccountDetailValidationDto addAccountDetailValidationDto = AddAccountDetailValidationDto.toDto(dto.getAccountHistoryId(), dto.getMoney());
            AccountHistory accountHistory = accountHistoryService.addAccountDetail(memberKey, addAccountDetailValidationDto);

            if(dto.getSmallCategory() == null) {
                dto.setSmallCategory(SmallCategory.valueOf(accountHistory.getLargeCategory().toString()));
            }

            AccountDetail accountDetail = AccountDetail.toAccountDetail(accountHistory, dto.getContent(), dto.getMoney(), dto.getSmallCategory());
            AccountDetail saveAccountDetail = accountDetailRepository.save(accountDetail);
        }
    }
}
