package com.keeping.missionservice.api.controller.mission;

import com.keeping.missionservice.api.ApiResponse;
import com.keeping.missionservice.api.controller.mission.request.RelationshipCheckRequest;
import com.keeping.missionservice.api.controller.mission.request.MemberTypeRequest;
import com.keeping.missionservice.api.controller.mission.response.ChildResponseList;
import com.keeping.missionservice.api.controller.mission.response.MemberRelationshipResponse;
import com.keeping.missionservice.api.controller.mission.response.MemberTypeResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "member-service", url = "https://j9c207.p.ssafy.io/api")
public interface MemberFeignClient {

    @PostMapping("/member-service/api/relationship")
    ApiResponse<MemberRelationshipResponse> getMemberRelationship(@RequestBody RelationshipCheckRequest request);

    @PostMapping("/member-service/api/type-check")
    ApiResponse<MemberTypeResponse> getMemberType(@RequestBody MemberTypeRequest request);

    @GetMapping("/member-service/api/{member-key}/children")
    ApiResponse<ChildResponseList> getChildren(@PathVariable(name = "member-key") String memberKey);
    
}
