package com.keeping.notiservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberFcmResponse {
    
    private boolean isPresent;
    
    private String FcmToken;


    @Builder
    public MemberFcmResponse(boolean isPresent, String fcmToken) {
        this.isPresent = isPresent;
        FcmToken = fcmToken;
    }
}
