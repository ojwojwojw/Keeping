package com.keeping.missionservice.api.controller.mission;

import com.keeping.missionservice.api.controller.mission.request.MemberRelationshipRequest;
import com.keeping.missionservice.api.controller.mission.request.MemberTypeRequest;
import com.keeping.missionservice.api.controller.mission.response.MemberRelationshipResponse;
import com.keeping.missionservice.api.controller.mission.response.MemberTypeResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "member-service")
public interface MemberFeignClient {

    @PostMapping("/relationship")
    MemberRelationshipResponse getMemberRelationship(@RequestBody MemberRelationshipRequest request);

    @PostMapping("/type-check")
    MemberTypeResponse getMemberType(@RequestBody MemberTypeRequest request);
    
}
