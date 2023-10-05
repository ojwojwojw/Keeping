package com.keeping.memberservice.api.controller;

import com.keeping.memberservice.api.ApiResponse;
import com.keeping.memberservice.api.controller.request.PasswordCheckRequest;
import com.keeping.memberservice.api.controller.request.SetFcmTokenRequest;
import com.keeping.memberservice.api.controller.request.UpdateLoginPwRequest;
import com.keeping.memberservice.api.controller.response.*;
import com.keeping.memberservice.api.service.AuthService;
import com.keeping.memberservice.api.service.member.MemberService;
import com.keeping.memberservice.api.service.member.dto.LinkResultDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/auth/api/{memberKey}")
@Slf4j
public class MemberAuthController {

    private final MemberService memberService;
    private final AuthService authService;

    @PostMapping("/{type}/link/{linkcode}")
    public ApiResponse<LinkResultResponse> link(@PathVariable String memberKey,
                                                @PathVariable String type,
                                                @PathVariable String linkcode) {
        // TODO: 2023-09-14 연결
        LinkResultDto result = authService.link(linkcode, memberKey, type);
        if (!result.isSuccess()) {
            return ApiResponse.of(1, HttpStatus.BAD_REQUEST, result.getFailMessage());
        }

        LinkResultResponse response = memberService.linkMember(memberKey, result.getPartner(), result.getRelation());
        return ApiResponse.ok(response);
    }

    @GetMapping("/link")
    public ApiResponse<String> whoLinkMe(@PathVariable String memberKey) {
        // TODO: 2023-09-26 해야함
        return ApiResponse.ok("김부모");
    }

    @GetMapping("/{type}/linkcode")
    public ApiResponse<LinkcodeResponse> getLinkcode(@PathVariable String memberKey,
                                                     @PathVariable String type) {
        LinkcodeResponse response = authService.getLinkCode(memberKey, type);
        if (response == null) {
            return ApiResponse.of(1, HttpStatus.NOT_FOUND, "생성된 인증번호가 없습니다.");
        }
        return ApiResponse.ok(response);
    }

    @PostMapping("/{type}/linkcode")
    public ApiResponse<LinkcodeResponse> createLinkcode(@PathVariable String memberKey,
                                                        @PathVariable String type) {
        boolean isParent = memberService.isParent(memberKey);
        if ((isParent && type.equals("parent")) ||
                (!isParent && type.equals("child"))) {
            String linkCode = authService.createLinkCode(type, memberKey);
            return ApiResponse.ok(createLinkcodeResponse(linkCode));
        } else {
            return ApiResponse.of(1, HttpStatus.BAD_REQUEST, "잘못된 요청입니다.");
        }

    }

    @GetMapping("/children")
    public ApiResponse<List<ChildrenResponse>> getChildrenList(@PathVariable String memberKey) {
        // TODO: 2023-09-14 자녀 목록 출력
        return ApiResponse.ok(null);
    }

    @PostMapping("/fcm-token")
    public ApiResponse<String> setFcmToken(@PathVariable String memberKey,
                                           @RequestBody @Valid SetFcmTokenRequest request) {
        // TODO: 2023-09-14 fcm token
        return ApiResponse.ok("");
    }

    @PostMapping("/profile/{imageNum}")
    public ApiResponse<String> updateProfileImage(@PathVariable String memberKey,
                                                  @PathVariable String imageNum) {
        // TODO: 2023-09-14 프로필 이미지 변경
        return ApiResponse.ok("");
    }

    @GetMapping
    public ApiResponse<MemberResponse> getMember(@PathVariable String memberKey) {
        // TODO: 2023-09-14 회원정보조회
        return ApiResponse.ok(MemberResponse.builder().build());
    }

    @DeleteMapping
    public ApiResponse<String> deleteMember(@PathVariable String memberKey) {
        // TODO: 2023-09-14 회원 탈퇴
        return ApiResponse.ok("탈퇴되었습니다.");
    }

    @PatchMapping
    public ApiResponse<String> updateLoginPw(@PathVariable String memberKey,
                                             @RequestBody @Valid UpdateLoginPwRequest request) {
        // TODO: 2023-09-14 비밀번호 변경
        return ApiResponse.ok("변경되었습니다. 다시 로그인하세요.");
    }

    @PostMapping("/password-check")
    public ApiResponse<String> passwordCheck(@RequestBody @Valid PasswordCheckRequest request) {
        // TODO: 2023-09-14 정보 변경 시 비밀번호 체크
        return ApiResponse.ok("");
    }

    @GetMapping("/login-check/{fcmToken}")
    public ApiResponse<LoginMember> getLoginMember(@PathVariable String memberKey, @PathVariable String fcmToken) {
        memberService.setFcmToken(memberKey,fcmToken);
        LoginMember loginUser = memberService.getLoginUser(memberKey);
        return ApiResponse.ok(loginUser);
    }

    private LinkcodeResponse createLinkcodeResponse(String linkCode) {
        return LinkcodeResponse.builder()
                .linkcode(linkCode)
                .expire(86400)
                .build();
    }
}
