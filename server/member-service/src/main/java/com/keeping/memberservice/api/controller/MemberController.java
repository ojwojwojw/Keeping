package com.keeping.memberservice.api.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.memberservice.api.ApiResponse;
import com.keeping.memberservice.api.controller.request.JoinParentRequest;
import com.keeping.memberservice.api.controller.request.SmsCheckRequest;
import com.keeping.memberservice.api.controller.request.SmsRequest;
import com.keeping.memberservice.api.service.AuthService;
import com.keeping.memberservice.api.service.member.MemberService;
import com.keeping.memberservice.api.service.member.dto.AddMemberDto;
import com.keeping.memberservice.api.service.sms.SmsService;
import com.keeping.memberservice.api.service.sms.dto.MessageDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

@RequiredArgsConstructor
@RestController
@RequestMapping("/member-service")
@Slf4j
public class MemberController {

    private final AuthService authService;
    private final SmsService smsService;
    private final MemberService memberService;

    @PostMapping("/join/parent")
    public ApiResponse<String> joinParent(@RequestBody @Valid JoinParentRequest request) {
        log.debug("[멤버 회원가입-Controller]");

        AddMemberDto dto = createAddMemberDto(request);

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
                // TODO: 2023-09-12 예리 - 인증번호 문자 다듬기
                .content(randomNumber)
                .build();

        smsService.sendSmsMessage(message);
        return ApiResponse.ok("인증번호가 전송되었습니다.");
    }

    private String makeUserPhone(String phoneString) {
        String[] phone = phoneString.split("-");

        return phone[0] + phone[1] + phone[2];
    }

    private AddMemberDto createAddMemberDto(JoinParentRequest request) {
        return AddMemberDto.builder()
                .loginId(request.getLoginId())
                .loginPw(request.getLoginPw())
                .name(request.getName())
                .phone(request.getPhone())
                .birth(request.getBirth()).build();
    }
}
