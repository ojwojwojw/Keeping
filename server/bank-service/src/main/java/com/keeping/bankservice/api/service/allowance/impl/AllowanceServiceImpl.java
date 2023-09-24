package com.keeping.bankservice.api.service.allowance.impl;

import com.keeping.bankservice.api.service.allowance.AllowanceService;
import com.keeping.bankservice.api.service.allowance.dto.AddAllowanceDto;
import com.keeping.bankservice.api.service.allowance.dto.ApproveAllowanceDto;
import com.keeping.bankservice.domain.allowance.Allowance;
import com.keeping.bankservice.domain.allowance.repository.AllowanceRepository;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import static com.keeping.bankservice.domain.allowance.Approve.WAIT;

@Service
@Transactional
@RequiredArgsConstructor
public class AllowanceServiceImpl implements AllowanceService {

    private final AllowanceRepository allowanceRepository;

    @Override
    public Long addAllowance(String childKey, AddAllowanceDto dto) {
        Allowance allowance = Allowance.toAllowance(childKey, dto.getContent(), dto.getMoney(), WAIT);
        Allowance saveAllowance = allowanceRepository.save(allowance);

        // TODO: 부모에게 푸시 알림 보내는 부분 추가

        return saveAllowance.getId();
    }

    @Override
    public void approveAllowance(String memberKey, ApproveAllowanceDto dto) {
        // TODO: 요청을 보낸 사용자가 부모인지 확인하는 부분 필요

        Allowance allowance = allowanceRepository.findById(dto.getAllowanceId())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 거래 내역이 존재하지 않습니다."));

        allowance.updateApproveStatus(dto.getApprove());
    }
}
