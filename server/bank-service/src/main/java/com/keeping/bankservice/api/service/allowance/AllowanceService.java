package com.keeping.bankservice.api.service.allowance;

import com.keeping.bankservice.api.controller.allowance.response.ShowAllowanceResponse;
import com.keeping.bankservice.api.service.allowance.dto.AddAllowanceDto;
import com.keeping.bankservice.api.service.allowance.dto.ApproveAllowanceDto;
import com.keeping.bankservice.domain.allowance.Approve;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional
public interface AllowanceService {
    Long addAllowance(String childKey, AddAllowanceDto dto);
    void approveAllowance(String memberKey, ApproveAllowanceDto dto);
    List<ShowAllowanceResponse> showAllowance(String memberKey, String targetKey);
    List<ShowAllowanceResponse> showTypeAllowance(String memberKey, String targetKey, Approve approve);
}
