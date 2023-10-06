package com.keeping.questionservice.api.controller;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.response.MemberTimeResponse;
import com.keeping.questionservice.api.controller.response.MemberTypeResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "member-service",  url = "https://j9c207.p.ssafy.io/api")
public interface MemberFeignClient {

    @GetMapping("/member-service/api/{member_key}/registration-time")
    ApiResponse<MemberTimeResponse> getMemberTime(@PathVariable(name = "member_key") String memberKey);

}
