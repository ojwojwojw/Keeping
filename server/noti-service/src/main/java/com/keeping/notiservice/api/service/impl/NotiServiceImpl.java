package com.keeping.notiservice.api.service.impl;

import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.api.service.FCMNotificationService;
import com.keeping.notiservice.api.service.NotiService;
import com.keeping.notiservice.api.service.dto.AddNotiDto;
import com.keeping.notiservice.api.service.dto.FCMNotificationDto;
import com.keeping.notiservice.api.service.dto.SendNotiDto;
import com.keeping.notiservice.domain.noti.Noti;
import com.keeping.notiservice.domain.noti.repository.NotiQueryRepository;
import com.keeping.notiservice.domain.noti.repository.NotiRepository;
import com.keeping.notiservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotiServiceImpl implements NotiService {
    
    private final FCMNotificationService fcmNotificationService;
    private final NotiRepository notiRepository;
    private final NotiQueryRepository notiQueryRepository;
    
    @Override
    public Long sendNoti(SendNotiDto dto) {

        // FCMNotificationDto로 분류
        FCMNotificationDto fcmDto = FCMNotificationDto.toDto(dto);

        fcmNotificationService.sendNotification(fcmDto);

        return addNoti(AddNotiDto.toDto(dto));
    }

    @Override
    public Long addNoti(AddNotiDto dto) {
        // 알림 저장하기
        Noti noti = notiRepository.save(Noti.toNoti(dto.getReceptionkey(), dto.getSentKey(), dto.getTitle(), dto.getContent(), dto.getType()));
        return noti.getId();
    }

    @Override
    public List<NotiResponse> showNoti(String memberKey) {
        return notiQueryRepository.showNoti(memberKey);
    }

    @Override
    public NotiResponse showDetailNoti(String memberKey, Long notiId) {
        return notiQueryRepository.showDetailNoti(memberKey, notiId)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 알람을 찾을 수 없습니다."));
    }
}
