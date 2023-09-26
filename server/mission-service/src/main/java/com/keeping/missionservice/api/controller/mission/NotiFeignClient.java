package com.keeping.missionservice.api.controller.mission;

import com.keeping.missionservice.api.ApiResponse;
import com.keeping.missionservice.api.controller.mission.request.SendNotiRequest;
import com.keeping.missionservice.api.controller.mission.response.NotiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "noti-service")
public interface NotiFeignClient {

    @PostMapping("/noti-service/send")
    ApiResponse<NotiResponse> sendNoti(@RequestBody SendNotiRequest request);
}
