package com.keeping.bankservice.api.service.allowance.impl;

import com.keeping.bankservice.api.controller.allowance.response.ShowAllowanceResponse;
import com.keeping.bankservice.api.service.allowance.AllowanceService;
import com.keeping.bankservice.api.service.allowance.dto.AddAllowanceDto;
import com.keeping.bankservice.api.service.allowance.dto.ApproveAllowanceDto;
import com.keeping.bankservice.domain.allowance.Allowance;
import com.keeping.bankservice.global.common.Approve;
import com.keeping.bankservice.domain.allowance.repository.AllowanceQueryRepository;
import com.keeping.bankservice.domain.allowance.repository.AllowanceRepository;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static com.keeping.bankservice.global.common.Approve.APPROVE;
import static com.keeping.bankservice.global.common.Approve.WAIT;

@Service
@Transactional
@RequiredArgsConstructor
public class AllowanceServiceImpl implements AllowanceService {

    private final AllowanceRepository allowanceRepository;
    private final AllowanceQueryRepository allowanceQueryRepository;

    @Override
    public Long addAllowance(String childKey, AddAllowanceDto dto) {
        Allowance allowance = Allowance.toAllowance(childKey, dto.getContent(), dto.getMoney(), WAIT);

        // TODO: 조르기 가능한 총 횟수 초과하지 않았는지 확인하는 부분 필요

        Allowance saveAllowance = allowanceRepository.save(allowance);

        // TODO: 부모에게 푸시 알림 보내는 부분 추가

        return saveAllowance.getId();
    }

    @Override
    public void approveAllowance(String memberKey, ApproveAllowanceDto dto) {
        // TODO: 요청을 보낸 사용자가 부모인지 확인하는 부분 필요

        Allowance allowance = allowanceRepository.findById(dto.getAllowanceId())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 용돈 조르기가 존재하지 않습니다."));

        allowance.updateApproveStatus(dto.getApprove());

        if(dto.getApprove() == APPROVE) {
            // TODO: 자녀에게 용돈 주는 부분 필요
        }
    }

    @Override
    public List<ShowAllowanceResponse> showAllowance(String memberKey, String targetKey) {
        if(!targetKey.equals(memberKey)) {
            // TODO: 타켓키가 멤버키의 자식인지 확인하는 부분 필요
        }

        List<ShowAllowanceResponse> result = allowanceQueryRepository.showAllowances(targetKey);

        return result;
    }

    @Override
    public List<ShowAllowanceResponse> showTypeAllowance(String memberKey, String targetKey, Approve approve) {
        if(!targetKey.equals(memberKey)) {
            // TODO: 타켓키가 멤버키의 자식인지 확인하는 부분 필요
        }

        List<ShowAllowanceResponse> result = allowanceQueryRepository.showTypeAllowances(targetKey, approve);

        return result;
    }
}
