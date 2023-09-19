package com.keeping.bankservice.api.service.account_history.impl;

import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.domain.account_history.repository.AccountHistoryQueryRepository;
import com.keeping.bankservice.domain.account_history.repository.AccountHistoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class AccountHistoryServiceImpl implements AccountHistoryService {

    private final AccountHistoryRepository accountHistoryRepository;
    private final AccountHistoryQueryRepository accountHistoryQueryRepository;
}
