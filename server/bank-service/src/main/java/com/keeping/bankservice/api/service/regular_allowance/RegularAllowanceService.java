package com.keeping.bankservice.api.service.regular_allowance;

import com.keeping.bankservice.api.service.regular_allowance.dto.MakeRegularAllowanceDto;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public interface RegularAllowanceService {
    Long makeRegularAllowance(String memberKey, MakeRegularAllowanceDto dto);
}
