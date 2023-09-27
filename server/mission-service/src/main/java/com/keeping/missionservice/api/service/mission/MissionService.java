package com.keeping.missionservice.api.service.mission;

import com.keeping.missionservice.api.controller.mission.request.AddMissionRequest;
import com.keeping.missionservice.api.controller.mission.response.MemberRelationshipResponse;
import com.keeping.missionservice.api.controller.mission.response.MissionResponse;
import com.keeping.missionservice.api.service.mission.dto.AddCommentDto;
import com.keeping.missionservice.api.service.mission.dto.AddMissionDto;
import com.keeping.missionservice.api.service.mission.dto.EditCompleteDto;
import com.keeping.missionservice.api.service.mission.dto.EditMissionDto;
import com.keeping.missionservice.domain.mission.Completed;

import java.util.List;

public interface MissionService {

    Long addMission(String memberKey, AddMissionDto dto);

    List<MissionResponse> showMission(String memberKey);
    
    MissionResponse showDetailMission(String memberKey, Long missionId);

    Long addComment(String memberKey, AddCommentDto dto);

    Long editCompleted(String memberKey, EditCompleteDto dto);

    Long editMission(String memberKey, EditMissionDto dto);

    Long removeMission(String memberKey, Long missionId);


    Long testBalance(String memberKey);
    MemberRelationshipResponse testMember(String memberKey, AddMissionRequest request);

}
