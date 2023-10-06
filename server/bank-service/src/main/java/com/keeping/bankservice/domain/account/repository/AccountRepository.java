package com.keeping.bankservice.domain.account.repository;

import com.keeping.bankservice.domain.account.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, Long> {
    Optional<Account> findById(Long id);
    Optional<Account> findByAccountNumber(String accountNumber);
    Optional<List<Account>> findByMemberKey(String memberKey);
}
