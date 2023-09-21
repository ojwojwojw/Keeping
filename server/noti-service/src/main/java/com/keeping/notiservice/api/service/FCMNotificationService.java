package com.keeping.notiservice.api.service;


import com.keeping.notiservice.api.service.dto.FCMNotificationDto;

public interface FCMNotificationService {
    public String sendNotification(FCMNotificationDto dto);
}
