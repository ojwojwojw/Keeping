package com.keeping.bankservice.api.service.online.impl;

import com.keeping.bankservice.api.service.online.OnlineService;
import com.keeping.bankservice.api.service.online.dto.AddOnlineDto;
import com.keeping.bankservice.api.service.online.dto.ApproveOnlineDto;
import com.keeping.bankservice.domain.online.Online;
import com.keeping.bankservice.domain.online.repository.OnlineQueryRepository;
import com.keeping.bankservice.domain.online.repository.OnlineRepository;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import static com.keeping.bankservice.global.common.Approve.APPROVE;
import static com.keeping.bankservice.global.common.Approve.WAIT;

@Service
@Transactional
@RequiredArgsConstructor
public class OnlineServiceImpl implements OnlineService {

    private final OnlineRepository onlineRepository;
    private final OnlineQueryRepository onlineQueryRepository;

    @Override
    public Long addOnline(String childKey, AddOnlineDto dto) {
        Online online = Online.toOnline(childKey, dto.getProductName(), dto.getUrl(), dto.getContent(), dto.getTotalMoney(), dto.getChildMoney(), null, WAIT);
        Online saveOnline = onlineRepository.save(online);

        // TODO: 부모에게 푸시 알림 보내는 부분 추가

        return saveOnline.getId();
    }

    @Override
    public void approveOnline(String memberKey, ApproveOnlineDto dto) {
        // TODO: 요청을 보낸 사용자가 부모인지 확인하는 부분 필요

        Online online = onlineRepository.findById(dto.getOnlineId())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 온라인 결제 조르기가 존재하지 않습니다."));

        online.updateApproveStatus(dto.getApprove());

        if(dto.getApprove() == APPROVE) {
            // TODO: 부모님한테서 출금하는 것 필요
        }
    }
}
