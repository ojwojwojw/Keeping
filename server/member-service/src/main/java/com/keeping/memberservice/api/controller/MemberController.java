package com.keeping.memberservice.api.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.memberservice.api.ApiResponse;
import com.keeping.memberservice.api.controller.request.*;
import com.keeping.memberservice.api.controller.response.ChildKeyResponse;
import com.keeping.memberservice.api.controller.response.RelationshipCheckResponse;
import com.keeping.memberservice.api.controller.response.TypeCheckResult;
import com.keeping.memberservice.api.service.AuthService;
import com.keeping.memberservice.api.service.member.MemberService;
import com.keeping.memberservice.api.service.member.dto.AddMemberDto;
import com.keeping.memberservice.api.service.sms.SmsService;
import com.keeping.memberservice.api.service.sms.dto.MessageDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

@RequiredArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api")
public class MemberController {

    private final AuthService authService;
    private final SmsService smsService;
    private final MemberService memberService;

    @GetMapping("/{memberKey}/fcm-key")
    public ApiResponse<String> getFcmToken(@PathVariable String memberKey) {
        String fcm = memberService.getFcmToken(memberKey);
        if (fcm == null) {
            return ApiResponse.of(1, HttpStatus.NO_CONTENT, "토큰이 발급되지 않은 회원입니다.");
        }
        return ApiResponse.ok(fcm);
    }

    @GetMapping("/{member_key}/children")
    public ApiResponse<List<ChildKeyResponse>> getChildList(@PathVariable String member_key) {
        List<ChildKeyResponse> list = memberService.getChildKeyList(member_key);
        return ApiResponse.ok(list);
    }

    @PostMapping("/type-check")
    public ApiResponse<TypeCheckResult> typeCheck(@RequestBody @Valid TypeCheckRequest request) {
        boolean result = memberService.typeCheck(request.getMemberKey(), request.getType());
        return ApiResponse.ok(TypeCheckResult.builder().isTypeRight(result).build());
    }

    @PostMapping("/relationship")
    public ApiResponse<RelationshipCheckResponse> isParentialRelationship(@RequestBody @Valid RelationshipCheckRequest request) {
        log.debug("부모키 = {}", request.getParentKey());
        RelationshipCheckResponse response = memberService.relationCheck(request.getParentKey(), request.getChildKey());
        return ApiResponse.ok(response);
    }

    @PostMapping("/password")
    public ApiResponse<String> getNewPassword(@RequestBody GetNewPasswordRequest request) {
        // TODO: 2023-09-14 비밀번호 찾기
        return ApiResponse.ok("연락처로 새로운 비밀번호가 발급되었습니다.");
    }

    @GetMapping("/logout/{memberKey}")
    public ApiResponse<String> logout(@PathVariable String memberKey) {
        // TODO: 2023-09-14 로그아웃
        return ApiResponse.ok("성공");
    }

    /**
     * 아이디 중복체크
     *
     * @param loginId 로그인 아이디
     * @return 결과
     */
    @GetMapping("/id/{loginId}")
    public ApiResponse<String> idDuplicateCheck(@PathVariable String loginId) {
        if (memberService.idDuplicateCheck(loginId)) {
            return ApiResponse.ok("사용 가능한 아이디입니다.");
        }
        return ApiResponse.of(1, HttpStatus.BAD_REQUEST, "사용할 수 없는 아이디입니다.");
    }

    @PostMapping("/join/child")
    public ApiResponse<String> joinChild(@RequestBody @Valid JoinChildRequest request) {
        log.debug("[자녀 회원가입-Controller]");

        AddMemberDto dto = createAddMemberDto(request.getLoginId(), request.getLoginPw(), request.getName(), request.getPhone(), request.getBirth());

        String result = memberService.addChild(dto, request.getParentPhone());

        return ApiResponse.ok(result);
    }

    @PostMapping("/join/parent")
    public ApiResponse<String> joinParent(@RequestBody @Valid JoinParentRequest request) {
        log.debug("[멤버 회원가입-Controller]");

        AddMemberDto dto = createAddMemberDto(request.getLoginId(), request.getLoginPw(), request.getName(), request.getPhone(), request.getBirth());

        String result = memberService.addParent(dto);

        return ApiResponse.ok(result);
    }

    @PostMapping("/phone-check")
    public ApiResponse<String> checkJoinSms(@RequestBody @Valid SmsCheckRequest request) throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException, InvalidKeyException, JsonProcessingException {
        log.debug("[멤버 회원가입-Controller] 인증번호 인증 요청. 인증번호 = {}", request.getCertification());

        String phone = makeUserPhone(request.getPhone());

        if (!authService.checkNumber(phone, request.getCertification())) {
            return ApiResponse.of(1, HttpStatus.BAD_REQUEST, "인증번호가 잘못 되었습니다.");
        }

        return ApiResponse.ok("인증되었습니다.");
    }

    @PostMapping("/phone")
    public ApiResponse<String> sendJoinSms(@RequestBody @Valid SmsRequest request) throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException, InvalidKeyException, JsonProcessingException {
        log.debug("인증번호 요청 들어옴");
        String phone = makeUserPhone(request.getPhone());

        String randomNumber = authService.getRandomCertification(phone);

        MessageDto message = MessageDto.builder()
                .to(phone)
                .content(getRandomNumberMessage(randomNumber))
                .build();

        smsService.sendSmsMessage(message);
        return ApiResponse.ok("인증번호가 전송되었습니다.");
    }

    private String getRandomNumberMessage(String randomNumber) {
        return "[키핑]\n" +
                "본인 인증 번호\n"
                + "[" + randomNumber + "]";
    }

    private String makeUserPhone(String phoneString) {
        String[] phone = phoneString.split("-");

        return phone[0] + phone[1] + phone[2];
    }

    private AddMemberDto createAddMemberDto(String loginId, String loginPw, String name, String phone, String birth) {
        return AddMemberDto.builder()
                .loginId(loginId)
                .loginPw(loginPw)
                .name(name)
                .phone(phone)
                .birth(birth)
                .build();
    }
}
