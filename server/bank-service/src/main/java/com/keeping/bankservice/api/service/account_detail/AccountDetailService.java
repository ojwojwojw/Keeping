package com.keeping.bankservice.api.service.account_detail;

import com.keeping.bankservice.api.service.account_detail.dto.AddAccountDetailDto;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public interface AccountDetailService {
    Long addAccountDetail(String memberKey, AddAccountDetailDto dto);
}
