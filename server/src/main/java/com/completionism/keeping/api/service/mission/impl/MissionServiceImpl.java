package com.completionism.keeping.api.service.mission.impl;

import com.completionism.keeping.api.service.mission.MissionService;
import com.completionism.keeping.api.service.mission.dto.AddMissionDto;
import com.completionism.keeping.domain.mission.Mission;
import com.completionism.keeping.domain.mission.repository.MissionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class MissionServiceImpl implements MissionService {
    
    private final MissionRepository missionRepository;

    /**
     *  미션 등록
     * @param dto 미션 등록 dto
     * @return 미션 식별키
     */
    @Override
    public Long addMission(AddMissionDto dto) {
        // TODO: 아이 연관관계 추가
        
        // TODO: 미션을 주는 사람은 requestbody에 담아서 오고, 그 사람이 진짜인지 검증을 거치고 Completed 설정 다르게 하기

        Mission mission = Mission.toMission(dto.getTodo(), dto.getMoney(), dto.getType(), dto.getStartDate(), dto.getEndDate(), dto.getCompleted());
        Mission savedMission = missionRepository.save(mission);
        return savedMission.getId();
    }
}
