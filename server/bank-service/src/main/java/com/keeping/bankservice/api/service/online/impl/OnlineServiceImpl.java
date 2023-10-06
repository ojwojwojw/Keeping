package com.keeping.bankservice.api.service.online.impl;

import com.keeping.bankservice.api.controller.feign_client.MemberFeignClient;
import com.keeping.bankservice.api.controller.feign_client.NotiFeignClient;
import com.keeping.bankservice.api.controller.feign_client.request.SendNotiRequest;
import com.keeping.bankservice.api.controller.online.response.ShowOnlineResponse;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.TransferToParentDto;
import com.keeping.bankservice.api.service.online.OnlineService;
import com.keeping.bankservice.api.service.online.dto.AddOnlineDto;
import com.keeping.bankservice.api.service.online.dto.ApproveOnlineDto;
import com.keeping.bankservice.domain.online.Online;
import com.keeping.bankservice.domain.online.repository.OnlineQueryRepository;
import com.keeping.bankservice.domain.online.repository.OnlineRepository;
import com.keeping.bankservice.global.common.Approve;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.URISyntaxException;
import java.util.List;

import static com.keeping.bankservice.global.common.Approve.APPROVE;
import static com.keeping.bankservice.global.common.Approve.WAIT;

@Service
@Transactional
@RequiredArgsConstructor
public class OnlineServiceImpl implements OnlineService {

    private final MemberFeignClient memberFeignClient;
    private final NotiFeignClient notiFeignClient;
    private final AccountHistoryService accountHistoryService;
    private final OnlineRepository onlineRepository;
    private final OnlineQueryRepository onlineQueryRepository;

    @Override
    public Long addOnline(String childKey, AddOnlineDto dto) {
        Online online = Online.toOnline(childKey, dto.getProductName(), dto.getUrl(), dto.getContent(), dto.getTotalMoney(), dto.getChildMoney(), null, WAIT);
        Online saveOnline = onlineRepository.save(online);

        String parentKey = memberFeignClient.getParentMemberKey(childKey).getResultBody();
        String name = memberFeignClient.getMemberName(childKey).getResultBody();

        notiFeignClient.sendNoti(childKey, SendNotiRequest.builder()
                .memberKey(parentKey)
                .title("온라인 결제 조르기 도착!! 💌")
                .content(name + " 님이 " + dto.getProductName() + "을 요청하셨어요")
                .type("ACCOUNT")
                .build());

        return saveOnline.getId();
    }

    @Override
    public void approveOnline(String memberKey, ApproveOnlineDto dto) throws URISyntaxException {
        // TODO: 요청을 보낸 사용자가 부모인지 확인하는 부분 필요

        Online online = onlineRepository.findById(dto.getOnlineId())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 온라인 결제 조르기가 존재하지 않습니다."));

        online.updateApproveStatus(dto.getApprove());
        online.updateComment(dto.getComment());

        if (dto.getApprove() == APPROVE) {
            // TODO: 자녀에게서 출금하는 것 필요
            TransferToParentDto transferToParentDto = TransferToParentDto.toDto(memberKey, online.getChildMoney());
            accountHistoryService.transferToParent(online.getChildKey(), transferToParentDto);

            notiFeignClient.sendNoti(memberKey, SendNotiRequest.builder()
                    .memberKey(online.getChildKey())
                    .title("온라인 결제 조르기 승인!️! ⭕")
                    .content("부모님이 " + online.getProductName() + " 요청을 승인하셨어요")
                    .type("ACCOUNT")
                    .build());
        } else {
            notiFeignClient.sendNoti(memberKey, SendNotiRequest.builder()
                    .memberKey(online.getChildKey())
                    .title("온라인 결제 조르기 거절!️! ❌")
                    .content("부모님이 " + online.getProductName() + " 요청을 거절하셨어요")
                    .type("ACCOUNT")
                    .build());
        }
    }

    @Override
    public List<ShowOnlineResponse> showOnline(String memberKey, String targetKey) {
        if (!targetKey.equals(memberKey)) {
            // TODO: 타켓키가 멤버키의 자식인지 확인하는 부분 필요
        }

        List<ShowOnlineResponse> result = onlineQueryRepository.showOnlines(targetKey);

        return result;
    }

    @Override
    public List<ShowOnlineResponse> showTypeOnline(String memberKey, String targetKey, Approve approve) {
        if (!targetKey.equals(memberKey)) {
            // TODO: 타켓키가 멤버키의 자식인지 확인하는 부분 필요
        }

        List<ShowOnlineResponse> result = onlineQueryRepository.showTypeOnlines(targetKey, approve);

        return result;
    }

    @Override
    public ShowOnlineResponse showDetailOnline(String memberKey, String targetKey, Long onlineId) {
        if (!targetKey.equals(memberKey)) {
            // TODO: 타켓키가 멤버키의 자식인지 확인하는 부분 필요
        }

        Online online = onlineRepository.findById(onlineId)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 온라인 결제 조르기가 존재하지 않습니다."));

        if (!online.getChildKey().equals(targetKey)) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "조회 권한이 없습니다.");
        }

        ShowOnlineResponse result = ShowOnlineResponse.toResponse(online);

        return result;
    }
}
