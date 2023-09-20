package com.keeping.bankservice.domain.account_history.repository;

import com.keeping.bankservice.domain.account_history.AccountHistory;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountHistoryRepository extends JpaRepository<AccountHistory, Long> {
}
