package com.keeping.bankservice.api.controller.feign_client;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.feign_client.request.MemberTypeRequest;
import com.keeping.bankservice.api.controller.feign_client.response.MemberKeyResponse;
import com.keeping.bankservice.api.controller.feign_client.response.MemberTypeResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

@FeignClient(name = "member-service", url = "https://j9c207.p.ssafy.io/api")
public interface MemberFeignClient {

    @GetMapping("/member-service/api/links")
    ApiResponse<List<MemberKeyResponse>> getChildMemberKey();

    @GetMapping("/member-service/api/{member-key}/parent")
    ApiResponse<String> getParentMemberKey(@PathVariable("member-key") String memberKey);

    @GetMapping("/member-service/api/{member-key}")
    ApiResponse<String> getMemberName(@PathVariable("member-key") String memberKey);

    @PostMapping("/member-service/api/type-check")
    ApiResponse<MemberTypeResponse> getMemberType(@RequestBody MemberTypeRequest request);
}
