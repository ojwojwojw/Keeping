package com.keeping.bankservice.api.service.regular_allowance.impl;

import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.TransferMoneyDto;
import com.keeping.bankservice.api.service.regular_allowance.RegularAllowanceService;
import com.keeping.bankservice.api.service.regular_allowance.dto.MakeRegularAllowanceDto;
import com.keeping.bankservice.domain.account.Account;
import com.keeping.bankservice.domain.account.repository.AccountRepository;
import com.keeping.bankservice.domain.regular_allowance.RegularAllowance;
import com.keeping.bankservice.domain.regular_allowance.repository.RegularAllowanceRepository;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.URISyntaxException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class RegularAllowanceServiceImpl implements RegularAllowanceService {

    private final AccountRepository accountRepository;
    private final AccountHistoryService accountHistoryService;
    private final RegularAllowanceRepository regularAllowanceRepository;

    @Override
    public Long makeRegularAllowance(String memberKey, MakeRegularAllowanceDto dto) {
        // TODO: 두 고유 번호가 부모-자녀 관계인지 확인하는 부분 필요

        Account parentAccount = accountRepository.findByMemberKey(memberKey)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 계좌가 존재하지 않습니다.")).get(0);

        Account childAccount = accountRepository.findByMemberKey(dto.getChildKey())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 계좌가 존재하지 않습니다.")).get(0);

        RegularAllowance regularAllowance = RegularAllowance.toRegularAllowance(memberKey, dto.getChildKey(), dto.getMoney(), dto.getDay());
        RegularAllowance saveRegularAllowance = regularAllowanceRepository.save(regularAllowance);

        return saveRegularAllowance.getId();
    }


    @Scheduled(cron = "0 0 0 * * *")
    public void depositAllowance() throws URISyntaxException {
        LocalDate today = LocalDate.now(ZoneId.of("Asia/Seoul"));
        int day = today.getDayOfMonth();

        List<RegularAllowance> regularAllowanceList = regularAllowanceRepository.findByDay(day);

        for(RegularAllowance regularAllowance: regularAllowanceList) {
            TransferMoneyDto transferMoneyDto = TransferMoneyDto.toDto(regularAllowance.getChildKey(), regularAllowance.getMoney());
            accountHistoryService.transferMoney(regularAllowance.getParentKey(), transferMoneyDto);
        }
    }
}
