package com.keeping.bankservice.domain.account_detail.repository;

import com.keeping.bankservice.domain.account_detail.AccountDetail;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountDetailRepository extends JpaRepository<AccountDetail, Long> {
}
