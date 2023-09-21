package com.keeping.bankservice.api.service.account_history;

import com.keeping.bankservice.api.service.account_history.dto.AddAccountDetailValidationDto;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import com.keeping.bankservice.domain.account_history.AccountHistory;
import org.springframework.transaction.annotation.Transactional;

import java.net.URISyntaxException;

@Transactional
public interface AccountHistoryService {
    Long addAccountHistory(String memberKey, AddAccountHistoryDto dto) throws URISyntaxException;
    AccountHistory addAccountDetail(String memberKey, AddAccountDetailValidationDto dto);
}
