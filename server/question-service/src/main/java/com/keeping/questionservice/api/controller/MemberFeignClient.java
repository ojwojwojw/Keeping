package com.keeping.questionservice.api.controller;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.response.MemberTimeResponse;
import com.keeping.questionservice.api.controller.response.MemberTypeResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "member_service")
public interface MemberFeignClient {

    @GetMapping("/{member_key}")
    ApiResponse<MemberTypeResponse> getMemberType(@PathVariable(name = "member_key") String memberKey);

    @GetMapping("/{member_key}")
    ApiResponse<MemberTimeResponse> getMemberTime(@PathVariable(name = "member_key") String memberKey);

}
