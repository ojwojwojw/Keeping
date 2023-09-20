package com.keeping.missionservice.api.controller.mission;

import com.keeping.missionservice.api.controller.mission.request.MemberRelationshipRequest;
import com.keeping.missionservice.api.controller.mission.response.MemberRelationshipResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "member-service")
public interface FromMemberApiController {

    @PostMapping("/relationship")
    MemberRelationshipResponse getMemberRelationship(@RequestBody MemberRelationshipRequest request);
    
}
