package com.keeping.bankservice.api.controller.feign_client;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.feign_client.request.SendNotiRequest;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "noti-service")
public interface NotiFeignClient {

    @PostMapping("/noti-service/api/{member_key}")
    ApiResponse<Long> sendNoti(@PathVariable(name = "member_key") String memberKey, @RequestBody SendNotiRequest request);
}
