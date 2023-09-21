package com.keeping.notiservice.api.controller;


import com.keeping.notiservice.api.controller.response.MemberFcmResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient("/member-service")
public interface MemberFeignClient {

    @GetMapping("/fcm-key/{member_key}")
    MemberFcmResponse getFCMKey(@PathVariable(name = "member_key") String memberKey);
    
}

