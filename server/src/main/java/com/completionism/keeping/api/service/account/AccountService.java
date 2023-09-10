package com.completionism.keeping.api.service.account;

import com.completionism.keeping.api.service.account.dto.AddAccountDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public interface AccountService {
    Long addAccount(String loginId, AddAccountDto dto) throws JsonProcessingException;
}
