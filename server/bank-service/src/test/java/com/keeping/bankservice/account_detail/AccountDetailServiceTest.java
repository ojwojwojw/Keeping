package com.keeping.bankservice.account_detail;

import com.keeping.bankservice.api.service.account_detail.AccountDetailService;
import com.keeping.bankservice.domain.account.repository.AccountRepository;
import com.keeping.bankservice.domain.account_detail.repository.AccountDetailRepository;
import com.keeping.bankservice.domain.account_history.repository.AccountHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@Transactional
public class AccountDetailServiceTest {

    @Autowired
    AccountRepository accountRepository;
    @Autowired
    AccountHistoryRepository accountHistoryRepository;
    @Autowired
    AccountDetailService accountDetailService;
    @Autowired
    AccountDetailRepository accountDetailRepository;
    @Autowired
    PasswordEncoder passwordEncoder;

//    @Test
//    @DisplayName("거래 상세 내역 등록")
//    void addAccountDetail() {
//        // given
//        String memberKey = "0986724";
//        Account account = insertAccount(memberKey);
//        AccountHistory accountHistory = insertAccountHistory(memberKey);
//
//    }
//
//    private Account insertAccount(String memberKey) throws JsonProcessingException {
//        Account account = Account.toAccount(memberKey, "123-456778-101-11", passwordEncoder.encode("123456"));
//
//        Long accountId = accountService.addAccount(memberKey, dto);
//
//        return accountRepository.findById(accountId).get();
//    }
}
