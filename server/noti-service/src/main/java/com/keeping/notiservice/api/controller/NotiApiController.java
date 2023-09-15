package com.keeping.notiservice.api.controller;

import com.keeping.notiservice.api.request.FCMNotificationRequest;
import com.keeping.notiservice.api.service.FCMNotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/noti-service")
@RequiredArgsConstructor
public class NotiApiController {
    
    private final FCMNotificationService fcmNotificationService;
    @PostMapping
    public String sendNotification(@RequestBody FCMNotificationRequest request) {
        return fcmNotificationService.sendNotification(request);
    }
    
}
