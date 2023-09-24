package com.keeping.bankservice.api.service.allowance;

import com.keeping.bankservice.api.service.allowance.dto.AddAllowanceDto;
import com.keeping.bankservice.api.service.allowance.dto.ApproveAllowanceDto;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public interface AllowanceService {
    Long addAllowance(String childKey, AddAllowanceDto dto);
    void approveAllowance(String memberKey, ApproveAllowanceDto dto);
}
