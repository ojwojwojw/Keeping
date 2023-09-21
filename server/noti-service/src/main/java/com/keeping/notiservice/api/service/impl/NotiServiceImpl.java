package com.keeping.notiservice.api.service.impl;

import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.api.service.FCMNotificationService;
import com.keeping.notiservice.api.service.NotiService;
import com.keeping.notiservice.api.service.dto.AddNotiDto;
import com.keeping.notiservice.api.service.dto.FCMNotificationDto;
import com.keeping.notiservice.api.service.dto.SendNotiDto;
import com.keeping.notiservice.domain.noti.Noti;
import com.keeping.notiservice.domain.noti.repository.NotiRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotiServiceImpl implements NotiService {
    
    private final FCMNotificationService fcmNotificationService;
    private final NotiRepository notiRepository;
    
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
        return null;
    }
}
