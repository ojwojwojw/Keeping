package com.keeping.missionservice.api.service.mission.impl;

import com.keeping.missionservice.api.ApiResponse;
import com.keeping.missionservice.api.controller.mission.BankFeignClient;
import com.keeping.missionservice.api.controller.mission.MemberFeignClient;
import com.keeping.missionservice.api.controller.mission.NotiFeignClient;
import com.keeping.missionservice.api.controller.mission.request.AddMissionRequest;
import com.keeping.missionservice.api.controller.mission.request.RelationshipCheckRequest;
import com.keeping.missionservice.api.controller.mission.request.MemberTypeRequest;
import com.keeping.missionservice.api.controller.mission.request.SendNotiRequest;
import com.keeping.missionservice.api.controller.mission.response.*;
import com.keeping.missionservice.api.service.mission.MissionService;
import com.keeping.missionservice.api.service.mission.dto.AddCommentDto;
import com.keeping.missionservice.api.service.mission.dto.AddMissionDto;
import com.keeping.missionservice.api.service.mission.dto.EditCompleteDto;
import com.keeping.missionservice.api.service.mission.dto.EditMissionDto;
import com.keeping.missionservice.domain.mission.Completed;
import com.keeping.missionservice.domain.mission.MemberType;
import com.keeping.missionservice.domain.mission.Mission;
import com.keeping.missionservice.domain.mission.MissionType;
import com.keeping.missionservice.domain.mission.repository.MissionQueryRepository;
import com.keeping.missionservice.domain.mission.repository.MissionRepository;
import com.keeping.missionservice.global.exception.AlreadyExistException;
import com.keeping.missionservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class MissionServiceImpl implements MissionService {

    private final MemberFeignClient memberFeignClient;
    private final BankFeignClient bankFeignClient;
    private final NotiFeignClient notiFeignClient;
    private final MissionQueryRepository missionQueryRepository;
    private final MissionRepository missionRepository;


    /**
     * 미션 등록
     *
     * @param dto 미션 등록 dto
     * @return 미션 식별키
     */
    @Override
    @Transactional
    public Long addMission(String memberKey, AddMissionDto dto) {

        // 부모가 자녀에게 미션을 주는 거라면 Completed(완성여부)를 YET으로 설정
        if (dto.getType().equals(MissionType.PARENT)) {
            // 해당 자녀가 있는지 확인
            MemberRelationshipResponse memberRelationship = memberFeignClient.getMemberRelationship(RelationshipCheckRequest.builder()
                            .parentKey(memberKey)
                            .childKey(dto.getTo())
                            .build())
                    .getResultBody();

            if (!memberRelationship.isParentialRelationship()) {
                throw new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 회원을 찾을 수 없습니다.");
            }

            // 부모의 계좌에 들어있는 잔액
            ApiResponse<Long> accountBalanceFromParent = bankFeignClient.getAccountBalanceFromParent(memberKey);
            Long limitAmount = accountBalanceFromParent.getResultBody();

            // 현재 완료하지 않은 미션 총액
            Optional<Integer> missionTotalMoney = missionQueryRepository.countMoney(dto.getTo());

            if (missionTotalMoney.isPresent() && missionTotalMoney.get() < limitAmount) {
                throw new AlreadyExistException("409", HttpStatus.CONFLICT, "잔액보다 미션 총액이 많습니다.");
            }

            // 첫날이 시작날보다 이른 날짜인지 확인
            if (dto.getStartDate().isAfter(dto.getEndDate())) {
                throw new NotFoundException("409", HttpStatus.CONFLICT, "해당하는 날짜를 입력할 수 없습니다.");
            }

            Mission mission = Mission.toMission(dto.getTo(), dto.getType(), dto.getTodo(), dto.getMoney(), dto.getCheeringMessage(), "", dto.getStartDate(), dto.getEndDate(), Completed.YET);
            Mission savedMission = missionRepository.save(mission);

            // 자녀에게 알림 전송
            notiFeignClient.sendNoti(memberKey, SendNotiRequest.builder()
                    .memberKey(dto.getTo())
                    .title("[" + dto.getTodo() + "]" + " 도착!! 😆")
                    .content("미션 페이지를 확인해주세요!")
                    .type("MISSION")
                    .build());

            return savedMission.getId();
        }

        // 자녀가 부모에게 미션을 요청하는 거라면 Completed(완성여부)를 CREATE_WAIT으로 설정
        else if (dto.getType().equals(MissionType.CHILD)) {
            // 해당 자녀가 있는지 확인
            MemberRelationshipResponse memberRelationship = memberFeignClient.getMemberRelationship(RelationshipCheckRequest.builder()
                            .parentKey(dto.getTo())
                            .childKey(memberKey)
                            .build())
                    .getResultBody();

            if (!memberRelationship.isParentialRelationship()) {
                throw new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 회원을 찾을 수 없습니다.");
            }

            Mission mission = Mission.toMission(memberKey, dto.getType(), dto.getTodo(), dto.getMoney(), "",dto.getChildRequestComment(), dto.getStartDate(), dto.getEndDate(), Completed.CREATE_WAIT);
            Mission savedMission = missionRepository.save(mission);

            //  부모에게 알림 전송
            notiFeignClient.sendNoti(memberKey, SendNotiRequest.builder()
                    .memberKey(dto.getTo())
                    .title("[" + dto.getTodo() + "]" + " 요청이 도착했어요~! 🎁")
                    .content("미션 페이지를 확인해주세요!")
                    .type("MISSION")
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
    @Transactional
    public Long addFinishedComment(String memberKey, AddCommentDto dto) {
        // 미션 있는지 id로 확인
        Mission mission = missionRepository.findMissionById(dto.getMissionId())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 미션을 찾을 수 없습니다."));

        mission.updateFinishedComment(dto.getComment());

        return dto.getMissionId();
    }

    @Override
    @Transactional
    public Long editCompleted(String memberKey, EditCompleteDto dto) {
        MemberTypeResponse memberType = memberFeignClient.getMemberType(MemberTypeRequest.builder()
                        .memberKey(memberKey)
                        .type(dto.getType())
                        .build())
                .getResultBody();

        log.debug("[미션 멤버 타입] : " + memberType.isTypeRight());

        // 맞지 않는 멤버와 타입일 떄
        if (!memberType.isTypeRight()) {
            throw new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 회원을 찾을 수 없습니다.");
        }

        // 미션 id로 미션 찾기
        Mission mission = missionRepository.findMissionById(dto.getMissionId())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 미션을 찾을 수 없습니다."));

        // 부모라면 CREATE_WAIT -> YET,  FINISH_WAIT -> FINISH
        if (dto.getType().equals(MemberType.PARENT)) {

            // 기존 상태와 바뀔 상태 비교 CREATE_WAIT -> YET
            if (mission.getCompleted().equals(Completed.CREATE_WAIT)
                    && dto.getCompleted().equals(Completed.YET)) {

                // 부모 통장의 잔액과 미션 총액을 비교
                ApiResponse<Long> accountBalanceFromParent = bankFeignClient.getAccountBalanceFromParent(memberKey);
                long limitAmount = accountBalanceFromParent.getResultBody();
                long totalMissionMoney = 0;

                // 아이들 목록 불러오기
                List<ChildResponse> children = memberFeignClient.getChildren(memberKey).getResultBody();
                for (ChildResponse child : children) {
                    // 현재 완료하지 않은 미션 총액
                    Optional<Integer> missionMoney = missionQueryRepository.countMoney(child.getChildKey());

                    if (missionMoney.isPresent()) {
                        totalMissionMoney += missionMoney.get();
                    }
                }

//                if (totalMissionMoney < limitAmount) {
//                    throw new AlreadyExistException("400", HttpStatus.BAD_REQUEST, "잔액보다 미션 총액이 많습니다.");
//                }

                // cheeringMessage 추가
                mission.updateCheeringMessage(dto.getCheeringMessage());
                mission.updateCompleted(dto.getCompleted());
            }
            // 기존 상태와 바뀔 상태 비교 FINISH_WAIT -> FINISH
            else if (mission.getCompleted().equals(Completed.FINISH_WAIT)
                    && dto.getCompleted().equals(Completed.FINISH)) {

                // 부모 계좌에서 아이 계좌로 돈 이동
                bankFeignClient.transferMoneyForMission(memberKey, mission.getMoney());

                mission.updateCompleted(dto.getCompleted());
            } else {
                throw new AlreadyExistException("400", HttpStatus.BAD_REQUEST, "완성 상태를 바꿀 수 없습니다.");
            }
        }
        // 자녀라면 YET -> FINISH_WAIT
        else if (dto.getType().equals(MemberType.CHILD)) {

            if (mission.getCompleted().equals(Completed.YET)
                    && dto.getCompleted().equals(Completed.FINISH_WAIT)) {

                mission.updateCompleted(dto.getCompleted());
            } else {
                throw new AlreadyExistException("409", HttpStatus.CONFLICT, "완성 상태를 바꿀 수 없습니다.");
            }

        } else {
            throw new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 회원 타입을 찾을 수 없습니다.");
        }
        return mission.getId();
    }

    @Override
    @Transactional
    public Long editMission(String memberKey, EditMissionDto dto) {
        // 미션 있는지 확인
        Mission mission = missionRepository.findMissionById(dto.getMissionId())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 미션을 찾을 수 없습니다."));

        // 부모 통장의 잔액과 미션 총액을 비교
        ApiResponse<Long> accountBalanceFromParent = bankFeignClient.getAccountBalanceFromParent(memberKey);
        Long limitAmount = accountBalanceFromParent.getResultBody();
        Long totalMissionMoney = 0l;

        // 아이들 목록 불러오기
        List<ChildResponse> children = memberFeignClient.getChildren(memberKey).getResultBody();
        for (ChildResponse child : children) {
            // 현재 완료하지 않은 미션 총액
            Optional<Integer> missionMoney = missionQueryRepository.countMoney(child.getChildKey());

            if (missionMoney.isPresent()) {
                totalMissionMoney += missionMoney.get();
            }
        }

        // 첫날이 시작날보다 이른 날짜인지 확인
        if (dto.getStartDate().isAfter(dto.getEndDate())) {
            throw new NotFoundException("409", HttpStatus.CONFLICT, "해당하는 날짜를 입력할 수 없습니다.");
        }

        mission.updateMission(dto.getTodo(), dto.getMoney(), dto.getCheeringMessage(), dto.getStartDate(), dto.getEndDate());

        return dto.getMissionId();
    }

    @Override
    @Transactional
    public Long removeMission(String memberKey, Long missionId) {
        // 미션 있는지 확인
        Mission mission = missionRepository.findMissionById(missionId)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 미션을 찾을 수 없습니다."));

        mission.deleteMission();

        return missionId;
    }

    @Override
    public Long testBalance(String memberKey) {

        log.debug("mission-test : {" + memberKey + "}");
        ApiResponse<Long> accountBalanceFromParent = bankFeignClient.getAccountBalanceFromParent(memberKey);

        log.debug("bank-feign-client");
        Long limitAmount = accountBalanceFromParent.getResultBody();

        log.debug("limitAmount: {" + limitAmount + "}");

        return limitAmount;
    }

    @Override
    public MemberRelationshipResponse testMember(String memberKey, AddMissionRequest request) {

        log.debug("member-test");

        return memberFeignClient.getMemberRelationship(RelationshipCheckRequest.builder()
                        .parentKey(memberKey)
                        .childKey(request.getTo())
                        .build())
                .getResultBody();
    }
}
