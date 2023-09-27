package com.keeping.notiservice.api.controller;


import com.keeping.notiservice.api.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "member-service", url = "http://j9c207.p.ssafy.io:8000")
public interface MemberFeignClient {

    @GetMapping("/member-service/api/{member_key}/fcm-key")
    ApiResponse<String> getFCMKey(@PathVariable(name = "member_key") String memberKey);
    
}

