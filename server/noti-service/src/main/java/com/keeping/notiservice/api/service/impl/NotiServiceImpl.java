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
import com.keeping.notiservice.domain.noti.Type;
import com.keeping.notiservice.domain.noti.repository.NotiQueryRepository;
import com.keeping.notiservice.domain.noti.repository.NotiRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotiServiceImpl implements NotiService {
    
    private final MemberFeignClient memberFeignClient;
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

        log.debug("[알림 전송] : " + memberKey);
        log.debug(dto.toString());

        // FCMNotificationDto로 분류
        FCMNotificationDto fcmDto = FCMNotificationDto.toDto(dto);

        String sendReturn = fcmNotificationService.sendNotification(fcmDto);

        ApiResponse<String> fcmKey = memberFeignClient.getFCMKey(memberKey);

        log.debug("[알림 전송 완료] : ");
        log.debug(sendReturn);
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

    @Override
    public List<NotiResponse> showNotiByType(String memberKey, String notiType) {
        return notiQueryRepository.findByMemberKeyAndType(memberKey, Type.valueOf(notiType));
    }

//    @Scheduled(cron = "0 0/2 * * * ?")
//    private void sendNotiTest() {
//        LocalTime localTime = LocalTime.now(ZoneId.of("Asia/Seoul"));
//        String time = localTime.format(DateTimeFormatter.ofPattern("HH:mm"));
//        log.debug("[알람 전송] 현재시간 : " + time);
//
//        String test = fcmNotificationService.sendNotification(FCMNotificationDto.builder()
//                .memberKey("test")
//                .title("테스트 알람이 도착했어요~!~💸")
//                .body("현재 시간은 " + time + "입니다.😆")
//                .build());
//
//        log.debug("결과값 : ");
//        log.debug(test);
//        log.debug("[알람 전송 성공]");/**/
//    }
}
