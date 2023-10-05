package com.keeping.bankservice.api.service.allowance.impl;

import com.keeping.bankservice.api.controller.allowance.response.ShowAllowanceResponse;
import com.keeping.bankservice.api.controller.feign_client.MemberFeignClient;
import com.keeping.bankservice.api.controller.feign_client.NotiFeignClient;
import com.keeping.bankservice.api.controller.feign_client.request.SendNotiRequest;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.TransferMoneyDto;
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

import java.net.URISyntaxException;
import java.text.DecimalFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

import static com.keeping.bankservice.global.common.Approve.APPROVE;
import static com.keeping.bankservice.global.common.Approve.WAIT;

@Service
@Transactional
@RequiredArgsConstructor
public class AllowanceServiceImpl implements AllowanceService {

    private final MemberFeignClient memberFeignClient;
    private final NotiFeignClient notiFeignClient;
    private final AccountHistoryService accountHistoryService;
    private final AllowanceRepository allowanceRepository;
    private final AllowanceQueryRepository allowanceQueryRepository;

    @Override
    public Long addAllowance(String childKey, AddAllowanceDto dto) {
        Allowance allowance = Allowance.toAllowance(childKey, dto.getContent(), dto.getMoney(), WAIT);

        // TODO: 조르기 가능한 총 횟수 초과하지 않았는지 확인하는 부분 필요

        Allowance saveAllowance = allowanceRepository.save(allowance);

        String parentKey = memberFeignClient.getParentMemberKey(childKey).getResultBody();
        String name = memberFeignClient.getMemberName(childKey).getResultBody();

        DecimalFormat decFormat = new DecimalFormat("###,###");
        String money = decFormat.format(dto.getMoney());

        notiFeignClient.sendNoti(childKey, SendNotiRequest.builder()
                .memberKey(parentKey)
                .title("용돈 조르기 도착!! 💵")
                .content(name + " 님이 " + money + "원을 요청하셨어요")
                .type("ACCOUNT")
                .build());

        return saveAllowance.getId();
    }

    @Override
    public void approveAllowance(String memberKey, ApproveAllowanceDto dto) throws URISyntaxException {
        // TODO: 요청을 보낸 사용자가 부모인지 확인하는 부분 필요

        Allowance allowance = allowanceRepository.findById(dto.getAllowanceId())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 용돈 조르기가 존재하지 않습니다."));

        allowance.updateApproveStatus(dto.getApprove());

        DecimalFormat decFormat = new DecimalFormat("###,###");
        String money = decFormat.format(allowance.getMoney());

        if (dto.getApprove() == APPROVE) {
            TransferMoneyDto transferMoneyDto = TransferMoneyDto.toDto(dto.getChildKey(), allowance.getMoney());
            accountHistoryService.transferMoney(memberKey, transferMoneyDto);

            notiFeignClient.sendNoti(memberKey, SendNotiRequest.builder()
                    .memberKey(allowance.getChildKey())
                    .title("용돈 조르기 승인!️! ⭕")
                    .content("부모님이 " + money + "원 요청을 승인하셨어요")
                    .type("ACCOUNT")
                    .build());
        } else {
            notiFeignClient.sendNoti(memberKey, SendNotiRequest.builder()
                    .memberKey(allowance.getChildKey())
                    .title("용돈 조르기 거절!!️ ❌")
                    .content("부모님이 " + money + "원 요청을 거절하셨어요")
                    .type("ACCOUNT")
                    .build());
        }
    }

    @Override
    public List<ShowAllowanceResponse> showAllowance(String memberKey, String targetKey) {
        if (!targetKey.equals(memberKey)) {
            // TODO: 타켓키가 멤버키의 자식인지 확인하는 부분 필요
        }

        List<ShowAllowanceResponse> result = allowanceQueryRepository.showAllowances(targetKey);

        return result;
    }

    @Override
    public List<ShowAllowanceResponse> showTypeAllowance(String memberKey, String targetKey, Approve approve) {
        if (!targetKey.equals(memberKey)) {
            // TODO: 타켓키가 멤버키의 자식인지 확인하는 부분 필요
        }

        List<ShowAllowanceResponse> result = allowanceQueryRepository.showTypeAllowances(targetKey, approve);

        return result;
    }

    @Override
    public int countMonthAllowance(String memberKey, String targetKey) {
        if (!targetKey.equals(memberKey)) {
            // TODO: 타켓키가 멤버키의 자식인지 확인하는 부분 필요
        }

        YearMonth month = YearMonth.now(ZoneId.of("Asia/Seoul"));
        LocalDate startDate = month.atDay(1);
        LocalDateTime startDateTime = startDate.atStartOfDay();
        LocalDateTime endDateTime = startDate.plusMonths(1).atStartOfDay().minusSeconds(1);

        int count = allowanceQueryRepository.countMonthAllowance(targetKey, startDateTime, endDateTime);

        return count;
    }
}
