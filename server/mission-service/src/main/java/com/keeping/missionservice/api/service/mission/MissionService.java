package com.keeping.missionservice.api.service.mission;

import com.keeping.missionservice.api.controller.mission.response.MissionResponse;
import com.keeping.missionservice.api.service.mission.dto.AddCommentDto;
import com.keeping.missionservice.api.service.mission.dto.AddMissionDto;
import com.keeping.missionservice.api.service.mission.dto.EditCompleteDto;
import com.keeping.missionservice.api.service.mission.dto.EditMissionDto;
import com.keeping.missionservice.domain.mission.Completed;

import java.util.List;

public interface MissionService {

    public Long addMission(AddMissionDto dto);
    
    public List<MissionResponse> showMission(String memberKey);
    
    public MissionResponse showDetailMission(String memberKey, Long missionId);

    public Long addComment(AddCommentDto dto);

    public Long editCompleted(EditCompleteDto dto);

    public Long editMission(EditMissionDto dto);

    public Long removeMission(String memberKey, Long missionId);
}
