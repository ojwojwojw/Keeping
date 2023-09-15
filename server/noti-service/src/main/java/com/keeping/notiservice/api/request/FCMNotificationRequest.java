package com.keeping.notiservice.api.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class FCMNotificationRequest {
    
    private Long targetUserId;
    
    private String title;
    
    private String body;
    
    @Builder
    public FCMNotificationRequest(Long targetUserId, String title, String body) {
        this.targetUserId = targetUserId;
        this.title = title;
        this.body = body;
    }
}
