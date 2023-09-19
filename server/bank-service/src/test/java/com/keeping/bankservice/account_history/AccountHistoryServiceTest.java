package com.keeping.bankservice.account_history;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.bankservice.api.controller.account_history.request.AddAccountHistoryRequest;
import com.keeping.bankservice.api.service.account.AccountService;
import com.keeping.bankservice.api.service.account.dto.AddAccountDto;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import com.keeping.bankservice.domain.account.Account;
import com.keeping.bankservice.domain.account.repository.AccountRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.net.URISyntaxException;

@SpringBootTest
@Transactional
public class AccountHistoryServiceTest {

    @Autowired
    AccountService accountService;
    @Autowired
    AccountRepository accountRepository;
    @Autowired
    AccountHistoryService accountHistoryService;

    @Test
    @DisplayName("거래 내역 등록")
    void addAccountHistory() throws JsonProcessingException, URISyntaxException {
        // given
        String memberKey = "0986724";
        Account account = insertAccount(memberKey);

        // when
        AddAccountHistoryRequest request = AddAccountHistoryRequest.builder()
                .accountNumber(account.getAccountNumber())
                .storeName("알리바이")
                .type(true)
                .money(3200l)
                .address("광주 광산구 왕버들로 11가동 101호")
                .build();

        // then
        AddAccountHistoryDto dto = AddAccountHistoryDto.toDto(request);
        Long accountHistoryId = accountHistoryService.addAccountHistory(memberKey, dto);
    }

    private Account insertAccount(String memberKey) throws JsonProcessingException {
        AddAccountDto dto = AddAccountDto.builder()
                .authPassword("123456")
                .build();

        Long accountId = accountService.addAccount(memberKey, dto);

        return accountRepository.findById(accountId).get();
    }
}
