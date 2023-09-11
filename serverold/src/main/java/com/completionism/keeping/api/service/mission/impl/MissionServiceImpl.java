package com.completionism.keeping.api.service.mission.impl;

import com.completionism.keeping.api.service.mission.MissionService;
import com.completionism.keeping.api.service.mission.dto.AddMissionDto;
import com.completionism.keeping.domain.mission.Completed;
import com.completionism.keeping.domain.mission.Mission;
import com.completionism.keeping.domain.mission.MissionType;
import com.completionism.keeping.domain.mission.repository.MissionRepository;
import com.completionism.keeping.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
@Transactional
public class MissionServiceImpl implements MissionService {
    
    private final MissionRepository missionRepository;
//    private final MemberQueryRepository memberQueryRepository; // TODO: member 완성시 해제
//    private final MemberRepository memberRepository; // TODO: member 완성시 해제

    /**
     *  미션 등록
     * @param dto 미션 등록 dto
     * @return 미션 식별키
     */
    @Override
    public Long addMission(String memberId, AddMissionDto dto) {
//        // memberId와 dto의 미션을 준 주체(dto.getType())로 해당 멤버가 있는지 확인
//        Member member = memberRepository.findByloginIdAndType(memberId, dto.getType()).orElseThrow(NotFoundException::new); // TODO: member완성시 해제
//
//        // TODO: 2023-09-08 부모의 계좌에 들어있는 금액 한도 내에서 가능
//
//        // 부모가 자녀에게 미션을 주는 거라면 Completed(완성여부)를 YET으로 설정
//        if (dto.getType().equals(MissionType.PARENT)) {
//            // TODO: 2023-09-08 해당 자녀가 있는지 확인 
//            Child child = childRepository.findBymemberId(dto.getTo()).orElseThrow(NotFoundException::new);
//
//            Mission mission = Mission.toMission(child, dto.getType(), dto.getTodo(), dto.getMoney(), dto.getCheeringMessage(),dto.getStartDate(), dto.getEndDate(), Completed.YET);
//            Mission savedMission = missionRepository.save(mission);
//
//            // TODO: 자녀에게 알림 전송
//
//            // TODO: 알림 저장
//
//            return savedMission.getId();
//        }
//
//        // 자녀가 부모에게 미션을 주는 거라면 Completed(완성여부)를 CREATE_WAIT으로 설정
//        else if (dto.getType().equals(MissionType.CHILD)) {
//            // TODO: 2023-09-08 해당 자녀가 있는지 확인 
//            Child child = childRepository.findBymemberId(memberId).orElseThrow(NotFoundException::new);
//
//            Mission mission = Mission.toMission(child, dto.getType(), dto.getTodo(), dto.getMoney(), dto.getCheeringMessage(), dto.getStartDate(), dto.getEndDate(), Completed.CREATE_WAIT);
//            Mission savedMission = missionRepository.save(mission);
//
//            // TODO: 부모에게 알림 전송
//
//            // TODO: 알림 저장
//
//            return savedMission.getId();
//        } else {
//            throw new NotFoundException("404", HttpStatus.NOT_FOUND, "해당 회원을 찾을 수 없습니다.");
//        }
        return null;
    }
}
