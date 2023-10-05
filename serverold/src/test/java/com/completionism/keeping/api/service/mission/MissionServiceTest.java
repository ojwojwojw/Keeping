package com.completionism.keeping.api.service.mission;

import com.completionism.keeping.domain.mission.Completed;
import com.completionism.keeping.domain.mission.Mission;
import com.completionism.keeping.domain.mission.MissionType;
import com.completionism.keeping.domain.mission.repository.MissionRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.ZoneId;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
class MissionServiceTest {
    
    @Autowired
    private MissionService missionService;
    
    @Autowired
    private MissionRepository missionRepository;
    
    @Test
    @DisplayName("미션 등록")
    void addMission() {
        // given
        
        // when
        
        // then
        
    }
    
    // 부모가 아이에게 미션 등록
    private Mission insertMissionFromParent() {
        Mission mission = Mission.builder()
                .todo("설거지 하기")
                .money(100)
                .type(MissionType.PARENT)
                .startDate(LocalDate.now())
                .endDate(LocalDate.now().plusDays(3))
                .completed(Completed.YET)
                .build();
        return missionRepository.save(mission);
    }
    
}