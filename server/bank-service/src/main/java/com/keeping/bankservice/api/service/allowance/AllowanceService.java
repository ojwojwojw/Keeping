package com.keeping.bankservice.api.service.allowance;

import com.keeping.bankservice.api.controller.allowance.response.ShowAllowanceResponse;
import com.keeping.bankservice.api.service.allowance.dto.AddAllowanceDto;
import com.keeping.bankservice.api.service.allowance.dto.ApproveAllowanceDto;
import com.keeping.bankservice.global.common.Approve;
import org.springframework.transaction.annotation.Transactional;

import java.net.URISyntaxException;
import java.util.List;

@Transactional
public interface AllowanceService {
    Long addAllowance(String childKey, AddAllowanceDto dto);
    void approveAllowance(String memberKey, ApproveAllowanceDto dto) throws URISyntaxException;
    List<ShowAllowanceResponse> showAllowance(String memberKey, String targetKey);
    List<ShowAllowanceResponse> showTypeAllowance(String memberKey, String targetKey, Approve approve);
    int countMonthAllowance(String memberKey, String targetKey);
}
