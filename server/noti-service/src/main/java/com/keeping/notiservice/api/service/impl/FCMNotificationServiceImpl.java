package com.keeping.notiservice.api.service.impl;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.keeping.notiservice.api.ApiResponse;
import com.keeping.notiservice.api.controller.MemberFeignClient;
import com.keeping.notiservice.api.controller.response.MemberFcmResponse;
import com.keeping.notiservice.api.service.dto.FCMNotificationDto;
import com.keeping.notiservice.api.service.FCMNotificationService;
import com.keeping.notiservice.domain.noti.repository.NotiRepository;
import com.keeping.notiservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FCMNotificationServiceImpl implements FCMNotificationService {

    private final FirebaseMessaging firebaseMessaging;
    private final NotiRepository notiRepository;
    private MemberFeignClient memberFeignClient; 
    
    @Override
    public String sendNotification(FCMNotificationDto dto) {

        // memberKey로 fcm token 가져오기
        ApiResponse<String> fcmKey = memberFeignClient.getFCMKey(dto.getMemberKey());

        // toekn 가져오기
        String token = fcmKey.getResultBody();
//        String token = "cm_uacCbSkuKgufTeKr_Gc:APA91bHYncdzysnQzuiQNe3fcifp5LujxbTAURrg_Y1g36mI6U7jbfou1N6wvzX5BVm54l815Vm83EcdUYbQ7HZ8grqLUYWotXliywPF4n4Rf-bjbarAWnHc6c4kJ67Zx3uueXdkhW_z";
        if (token != null) {
            // FCM 토큰이 존재하지 않을 때
            Notification notification = Notification.builder()
                    .setTitle(dto.getTitle())
                    .setBody(dto.getBody())
                    .build();

            Message message = Message.builder()
                    .setToken(token)
                    .setNotification(notification)
                    .build();

            try {
                firebaseMessaging.send(message);
                return "알림을 성공적으로 전송했습니다.";
            } catch (FirebaseMessagingException e) {
                return "알림 보내기를 실패하였습니다.";
            }
        }
        return "서버에 저장된 해당 유저의 FirebaseToken이 존재하지 않습니다.";
    } 
}
