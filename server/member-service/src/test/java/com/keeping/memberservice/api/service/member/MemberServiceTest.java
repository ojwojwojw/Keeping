package com.keeping.memberservice.api.service.member;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.memberservice.IntegrationTestSupport;
import com.keeping.memberservice.api.service.AuthService;
import com.keeping.memberservice.api.service.member.dto.AddMemberDto;
import com.keeping.memberservice.domain.Member;
import com.keeping.memberservice.domain.repository.MemberRepository;
import com.keeping.memberservice.domain.repository.ParentRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;

@Transactional
class MemberServiceTest extends IntegrationTestSupport {

    @Autowired
    private MemberService memberService;
    @Autowired
    private MemberRepository memberRepository;
    @Autowired
    private ParentRepository parentRepository;
    @Autowired
    private AuthService authService;

    @DisplayName("[자녀 회원가입-service] 아이디가 중복 시 예외가 발생한다.")
    @Test
    void addChildIdError() {
        //given
        insertMember();
        AddMemberDto dto = createAddMemberDto("keeping");

        //when
        //then
        assertThatThrownBy(() -> memberService.addChild(dto,"010-1231-1234"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("이미 존재하는 아이디입니다.");
    }

    @DisplayName("[자녀 회원가입-service] 부모 문자 인증 예외")
    @Test
    void addChildPhoneError_Parent() {
        //given
        AddMemberDto dto = createAddMemberDto("keeping");
        String phone = makeUserPhone(dto.getPhone());
        String randomNumber = authService.getRandomCertification(phone);
        authService.checkNumber(phone, randomNumber);
        String parentPhone = "01022221111";
        String randomNumberParent = authService.getRandomCertification(parentPhone);
        authService.checkNumber(parentPhone, randomNumberParent);
        //when
        //then
        assertThatThrownBy(() -> memberService.addChild(dto,"010-2312-3123"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("부모님의 문자 인증이 완료되지 않았습니다.");
    }

    @DisplayName("[자녀 회원가입-service] 본인 문자 인증 예외")
    @Test
    void addChildPhoneError() {
        //given
        AddMemberDto dto = createAddMemberDto("keeping");

        //when
        //then
        assertThatThrownBy(() -> memberService.addChild(dto,"010-0231-2312"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("문자 인증이 완료되지 않았습니다.");
    }

    @DisplayName("[자녀 회원가입-service]")
    @Test
    void addChild() throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException, InvalidKeyException, JsonProcessingException {
        //given
        AddMemberDto dto = createAddMemberDto("keeping");
        String phone = makeUserPhone(dto.getPhone());
        String randomNumber = authService.getRandomCertification(phone);
        System.out.println(randomNumber);
        authService.checkNumber(phone, randomNumber);
        String parentPhone = "01022221111";
        String randomNumberParent = authService.getRandomCertification(parentPhone);
        authService.checkNumber(parentPhone, randomNumberParent);

        //when
        String result = memberService.addChild(dto,"010-2222-1111");

        //then
        Optional<Member> savedMember = memberRepository.findByLoginId(dto.getLoginId());
        assertThat(savedMember).isPresent();
        parentRepository.findByMember(savedMember.get());
        assertThat(result).isEqualTo(dto.getName());
    }

    @DisplayName("[부모 회원가입-service] 아이디가 중복 시 예외가 발생한다.")
    @Test
    void addParentIdError() {
        //given
        insertMember();
        AddMemberDto dto = createAddMemberDto("keeping");

        //when
        //then
        assertThatThrownBy(() -> memberService.addParent(dto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("이미 존재하는 아이디입니다.");
    }

    @DisplayName("[부모 회원가입-service] 문자 인증 예외")
    @Test
    void addParentPhoneError() {
        //given
        AddMemberDto dto = createAddMemberDto("keeping");

        //when
        //then
        assertThatThrownBy(() -> memberService.addParent(dto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("문자 인증이 완료되지 않았습니다.");
    }

    @DisplayName("[부모 회원가입-service]")
    @Test
    void addParent() throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException, InvalidKeyException, JsonProcessingException {
        //given
        AddMemberDto dto = createAddMemberDto("keeping");
        String phone = makeUserPhone(dto.getPhone());
        String randomNumber = authService.getRandomCertification(phone);
        System.out.println(randomNumber);
        authService.checkNumber(phone, randomNumber);

        //when
        String result = memberService.addParent(dto);

        //then
        Optional<Member> savedMember = memberRepository.findByLoginId(dto.getLoginId());
        assertThat(savedMember).isPresent();
        parentRepository.findByMember(savedMember.get());
        assertThat(result).isEqualTo(dto.getName());
    }

    private Member insertMember() {
        Member savedMember = Member.builder()
                .loginId("keeping")
                .encryptionPw("encryptionPw")
                .memberKey("memberKey")
                .name("사용자")
                .phone("010-1234-1111")
                .build();
        return memberRepository.save(savedMember);
    }

    private static AddMemberDto createAddMemberDto(String loginId) {
        return AddMemberDto.builder()
                .loginId(loginId)
                .loginPw("loginPw123!")
                .name("양수원")
                .phone("010-0000-1111")
                .birth("2000-05-05")
                .build();
    }

    private String makeUserPhone(String phoneString) {
        String[] phone = phoneString.split("-");

        return phone[0] + phone[1] + phone[2];
    }
}