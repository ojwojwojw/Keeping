package com.keeping.missionservice.api.service.mission.impl;

import com.keeping.missionservice.api.controller.mission.BankFeignClient;
import com.keeping.missionservice.api.controller.mission.MemberFeignClient;
import com.keeping.missionservice.api.controller.mission.NotiFeignClient;
import com.keeping.missionservice.api.controller.mission.request.MemberRelationshipRequest;
import com.keeping.missionservice.api.controller.mission.request.SendNotiRequest;
import com.keeping.missionservice.api.controller.mission.response.AccountResponse;
import com.keeping.missionservice.api.controller.mission.response.MemberRelationshipResponse;
import com.keeping.missionservice.api.controller.mission.response.MissionResponse;
import com.keeping.missionservice.api.service.mission.MissionService;
import com.keeping.missionservice.api.service.mission.dto.AddMissionDto;
import com.keeping.missionservice.api.service.mission.dto.EditMissionDto;
import com.keeping.missionservice.domain.mission.Completed;
import com.keeping.missionservice.domain.mission.Mission;
import com.keeping.missionservice.domain.mission.MissionType;
import com.keeping.missionservice.domain.mission.repository.MissionQueryRepository;
import com.keeping.missionservice.domain.mission.repository.MissionRepository;
import com.keeping.missionservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class MissionServiceImpl implements MissionService {
    
    private MemberFeignClient memberFeignClient;
    private BankFeignClient bankFeignClient;
    private NotiFeignClient notiFeignClient;
    private final MissionQueryRepository missionQueryRepository;
    private final MissionRepository missionRepository;

    /**
     *  미션 등록
     * @param dto 미션 등록 dto
     * @return 미션 식별키
     */
    @Override
    public Long addMission(AddMissionDto dto) {
        String memberKey = dto.getMemberKey();
        // 부모의 계좌에 들어있는 금액 한도 내에서 가능
        AccountResponse parentBalance = bankFeignClient.getAccountBalanceFromParent(memberKey);
        int limitAmount = parentBalance.getBalance();

        // 부모가 자녀에게 미션을 주는 거라면 Completed(완성여부)를 YET으로 설정
        if (dto.getType().equals(MissionType.PARENT)) {
            // 해당 자녀가 있는지 확인
            MemberRelationshipResponse memberRelationship = memberFeignClient.getMemberRelationship(MemberRelationshipRequest.builder()
                    .parentKey(memberKey)
                    .childKey(dto.getTo())
                    .build());

            if (!memberRelationship.isParentialRelationship()) {
                throw new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 회원을 찾을 수 없습니다.");
            }


            Mission mission = Mission.toMission(dto.getTo(), dto.getType(), dto.getTodo(), dto.getMoney(), dto.getCheeringMessage(),dto.getStartDate(), dto.getEndDate(), Completed.YET);
            Mission savedMission = missionRepository.save(mission);

            // 자녀에게 알림 전송
            notiFeignClient.sendNoti(SendNotiRequest.builder()
                    .memberKey(dto.getTo())
                    .title("미션 도착!! 😆")
                    .body(dto.getTodo())
                    .build());

            return savedMission.getId();
        }

        // 자녀가 부모에게 미션을 주는 거라면 Completed(완성여부)를 CREATE_WAIT으로 설정
        else if (dto.getType().equals(MissionType.CHILD)) {
            // 해당 자녀가 있는지 확인
            MemberRelationshipResponse memberRelationship = memberFeignClient.getMemberRelationship(MemberRelationshipRequest.builder()
                    .parentKey(dto.getTo())
                    .childKey(memberKey)
                    .build());

            if (!memberRelationship.isParentialRelationship()) {
                throw new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 회원을 찾을 수 없습니다.");
            }

            Mission mission = Mission.toMission(memberKey, dto.getType(), dto.getTodo(), dto.getMoney(), dto.getCheeringMessage(), dto.getStartDate(), dto.getEndDate(), Completed.CREATE_WAIT);
            Mission savedMission = missionRepository.save(mission);

            //  부모에게 알림 전송
            notiFeignClient.sendNoti(SendNotiRequest.builder()
                    .memberKey(dto.getTo())
                    .title("🎁미션 요청이 도착했어요~! ")
                    .body(dto.getTodo())
                    .build());

            return savedMission.getId();
        } else {
            throw new NotFoundException("404", HttpStatus.NOT_FOUND, "해당 회원을 찾을 수 없습니다.");
        }
    }

    @Override
    public List<MissionResponse> showMission(String memberKey) {
        return missionQueryRepository.showMission(memberKey);
    }

    @Override
    public MissionResponse showDetailMission(String memberKey, Long missionId) {
        // 상세 미션 조회
        return missionQueryRepository.showDetailMission(memberKey, missionId)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 미션을 찾을 수 없습니다."));
    }

    @Override
    public Long addComment(String memberId, Long missionId) {
        return null;
    }

    @Override
    public Long editCompleted(String memberId, Long missionId, Completed completed) {
        return null;
    }

    @Override
    public Long editMission(EditMissionDto dto) {
        return null;
    }

    @Override
    public Long removeMission(String memberId, Long missionId) {
        return null;
    }
}
