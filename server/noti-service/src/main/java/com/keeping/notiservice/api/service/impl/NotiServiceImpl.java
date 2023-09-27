package com.keeping.notiservice.api.service.impl;

import com.keeping.notiservice.api.ApiResponse;
import com.keeping.notiservice.api.controller.MemberFeignClient;
import com.keeping.notiservice.api.controller.request.QuestionNotiRequest;
import com.keeping.notiservice.api.controller.request.QuestionNotiRequestList;
import com.keeping.notiservice.api.controller.response.MemberFcmResponse;
import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.api.service.FCMNotificationService;
import com.keeping.notiservice.api.service.NotiService;
import com.keeping.notiservice.api.service.dto.AddNotiDto;
import com.keeping.notiservice.api.service.dto.FCMNotificationDto;
import com.keeping.notiservice.api.service.dto.SendNotiDto;
import com.keeping.notiservice.domain.noti.Noti;
import com.keeping.notiservice.domain.noti.repository.NotiQueryRepository;
import com.keeping.notiservice.domain.noti.repository.NotiRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotiServiceImpl implements NotiService {
    
    private MemberFeignClient memberFeignClient;
    private final FCMNotificationService fcmNotificationService;
    private final NotiQueryRepository notiQueryRepository;
    private final NotiRepository notiRepository;

    @Override
    public void sendNotis(QuestionNotiRequestList requestList) {
        List<QuestionNotiRequest> requests = requestList.getRequestList();

        for (QuestionNotiRequest request : requests) {
            FCMNotificationDto fcmDto = FCMNotificationDto.toDto(request);

            fcmNotificationService.sendNotification(fcmDto);

            ApiResponse<String> fcmKey = memberFeignClient.getFCMKey(request.getMemberKey());
            addNoti(AddNotiDto.toDto(request, fcmKey.getResultBody()));
        }
    }

    @Override
    public Long sendNoti(String memberKey, SendNotiDto dto) {

        // FCMNotificationDto로 분류
        FCMNotificationDto fcmDto = FCMNotificationDto.toDto(dto);

        fcmNotificationService.sendNotification(fcmDto);

        ApiResponse<String> fcmKey = memberFeignClient.getFCMKey(memberKey);
        return addNoti(AddNotiDto.toDto(dto, fcmKey.getResultBody()));
    }

    @Override
    public Long addNoti(AddNotiDto dto) {
        // 알림 저장하기
        Noti noti = notiRepository.save(Noti.toNoti(dto.getMemberKey(), dto.getFcmToken(), dto.getTitle(), dto.getContent(), dto.getType()));
        return noti.getId();
    }

    @Override
    public List<NotiResponse> showNoti(String memberKey) {
        return notiQueryRepository.findByMemberKey(memberKey);
    }
}
