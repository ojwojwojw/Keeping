package com.keeping.notiservice.api.service.impl;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.keeping.notiservice.api.request.FCMNotificationRequest;
import com.keeping.notiservice.api.service.FCMNotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FCMNotificationServiceImpl implements FCMNotificationService {

    private final FirebaseMessaging firebaseMessaging;
    // TODO: 2023-09-08 memberRepository 추가 

    @Override
    public String sendNotification(FCMNotificationRequest request) {

        // TODO: 2023-09-08 targetUserId로 member 객체 찾기

        // TODO: 2023-09-08 사용자가 존재할 때 

        // TODO: 2023-09-08 사용자의 fcm 토큰 가져오기 
        String token = "";

        // FCM 토큰이 존재하지 않을 때
        Notification notification = Notification.builder()
                .setTitle(request.getTitle())
                .setBody(request.getBody())
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
}
