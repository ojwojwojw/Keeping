package com.completionism.keeping.api.service.mission;

import com.completionism.keeping.api.service.mission.dto.AddMissionDto;

public interface MissionService {

    public Long addMission(String memberId, AddMissionDto dto);
}
