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

@Service
@Transactional
@RequiredArgsConstructor
public class AccountDetailServiceImpl implements AccountDetailService {

    private AccountHistoryService accountHistoryService;
    private AccountDetailRepository accountDetailRepository;

    @Override
    public Long addAccountDetail(String memberKey, AddAccountDetailDto dto) {
        // 연결된 거래 내역 검증 -> remain, detailed 컬럼 값 갱신
        AddAccountDetailValidationDto addAccountDetailValidationDto = AddAccountDetailValidationDto.toDto(dto.getAccountHistoryId(), dto.getMoney());
        AccountHistory accountHistory = accountHistoryService.addAccountDetail(memberKey, addAccountDetailValidationDto);

        AccountDetail accountDetail = AccountDetail.toAccountDetail(accountHistory, dto.getContent(), dto.getMoney(), SmallCategory.valueOf(accountHistory.getLargeCategory().toString()));
        AccountDetail saveAccountDetail = accountDetailRepository.save(accountDetail);

        return saveAccountDetail.getId();
    }
}
