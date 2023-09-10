package com.completionism.keeping.api.service.account;

import com.completionism.keeping.api.service.account.dto.AddAccountDto;
import com.completionism.keeping.domain.account.Account;
import com.completionism.keeping.domain.account.repository.AccountRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

@SpringBootTest
@Transactional
public class AccountServiceTest {

    @Autowired
    AccountService accountService;

    @Autowired
    AccountRepository accountRepository;


    @Test
    @DisplayName("계좌 개설")
    void addAccount() throws JsonProcessingException {
        // given
        AddAccountDto dto = AddAccountDto.builder()
                .authPassword("123456")
                .build();

        // when
        Long id = accountService.addAccount("shinhan", dto);

        // then
        Optional<Account> findAccount = accountRepository.findById(id);
        assertThat(findAccount).isPresent();
    }
}
