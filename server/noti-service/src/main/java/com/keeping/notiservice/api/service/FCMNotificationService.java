package com.keeping.notiservice.api.service;


import com.keeping.notiservice.api.request.FCMNotificationRequest;

public interface FCMNotificationService {
    public String sendNotification(FCMNotificationRequest request);
}
