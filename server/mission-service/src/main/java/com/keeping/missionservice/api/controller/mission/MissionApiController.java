package com.keeping.missionservice.api.controller.mission;

import com.keeping.missionservice.api.ApiResponse;
import com.keeping.missionservice.api.controller.mission.request.AddMissionRequest;
import com.keeping.missionservice.api.controller.mission.request.CommentRequest;
import com.keeping.missionservice.api.controller.mission.request.EditCompleteRequest;
import com.keeping.missionservice.api.controller.mission.request.EditMissionRequest;
import com.keeping.missionservice.api.controller.mission.response.MissionResponse;
import com.keeping.missionservice.api.service.mission.MissionService;
import com.keeping.missionservice.api.service.mission.dto.AddMissionDto;
import com.keeping.missionservice.api.service.mission.dto.EditMissionDto;
import com.keeping.missionservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.ws.rs.Path;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/mission-service")
@Slf4j
public class MissionApiController {

    private final MissionService missionService;

    /**
     * 미션 등록
     *
     * @param request 미션 request
     * @return 미션 식별키
     */
    @PostMapping
    public ApiResponse<Long> addMission(
            @Valid @RequestBody AddMissionRequest request
    ) {
        log.debug("addMission :: request={}", request);
        log.info("addMission :: request={}", request);

        AddMissionDto dto = AddMissionDto.toDto(request);

        try {
            Long missionId = missionService.addMission(request.getMemberKey(), dto);
            return ApiResponse.ok(missionId);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage(), null);
        }
    }

    @PutMapping
    public ApiResponse<Long> editMission(
            @Valid @RequestBody EditMissionRequest request
    ) {
        // 사용자 정보 가져오기
        String memberId = null;

        try {
            Long missionId = missionService.editMission(memberId, EditMissionDto.toDto(request));
            return ApiResponse.ok(missionId);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage(), null);
        }
    }

    @GetMapping("/{member_key}")
    public ApiResponse<List<MissionResponse>> showMission(
            @PathVariable("member_key") String memberKey
    ) {
        String memberId = null;

        try {
            List<MissionResponse> missionResponses = missionService.showMission(memberId);
            return ApiResponse.ok(missionResponses);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage(), null);
        }

    }

    @GetMapping("/{member_key}/{mission_id}")
    public ApiResponse<MissionResponse> showDetailMission(
            @PathVariable("member_key") String memberKey,
            @PathVariable("mission_id") Long missionId
    ) {
        String memberId = null;

        try {
            MissionResponse response = missionService.showDetailMission(memberId, missionId);
            return ApiResponse.ok(response);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage(), null);
        }
    }

    @PostMapping("/comment")
    public ApiResponse<Long> addComment(
            @Valid @RequestBody CommentRequest request
    ) {
        try {
            Long missionId = missionService.addComment(request.getMemberKey(), request.getMissionId()); 
            return ApiResponse.ok(missionId);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage(), null);
        }
    }

    @PostMapping("/complete")
    public ApiResponse<Long> editComplete(
        @Valid @RequestBody EditCompleteRequest request    
    ) {
        try {
            Long missionId = missionService.editCompleted(request.getMemberKey(), request.getMissionId(), request.getCompleted());
            return ApiResponse.ok(missionId);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage(), null);
        }
    } 
}
