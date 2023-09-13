package com.keeping.memberservice.api.service.member;

import com.keeping.memberservice.api.service.AuthService;
import com.keeping.memberservice.api.service.member.dto.AddMemberDto;
import com.keeping.memberservice.domain.Member;
import com.keeping.memberservice.domain.Parent;
import com.keeping.memberservice.domain.repository.MemberRepository;
import com.keeping.memberservice.domain.repository.ParentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.UUID;

@RequiredArgsConstructor
@Service
@Transactional
@Slf4j
public class MemberService implements UserDetailsService {

    private final ParentRepository parentRepository;
    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final AuthService authService;

    @Override
    public UserDetails loadUserByUsername(String loginId) throws UsernameNotFoundException {
        Optional<Member> findMember = memberRepository.findByLoginId(loginId);

        if (findMember.isEmpty()) {
            throw new UsernameNotFoundException("등록되지 않는 사용자입니다.");
        }

        Member member = findMember.get();
        return new User(member.getLoginId(), member.getEncryptionPw(),
                true, true, true, true,
                new ArrayList<>()); //권한
    }

    public Member getUserDetailsByLoginId(String loginId) {
        Member member = memberRepository.findByLoginId(loginId).orElseThrow(() -> new NoSuchElementException("등록되지 않은 사용자입니다."));

        return member;
    }

    public String addParent(AddMemberDto dto) {
        // 아이디 중복 검사
        Optional<Member> findMember = memberRepository.findByLoginId(dto.getLoginId());

        if (findMember.isPresent()) {
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }

        //번호 인증 검사
        if (!authService.joinUserConfirm(makeUserPhone(dto.getPhone()))) {
            throw new IllegalArgumentException("문자 인증이 완료되지 않았습니다.");
        }

        //가입
        dto.setMemberKey(UUID.randomUUID().toString());
        Member newMember = dto.toEntity(passwordEncoder.encode(dto.getLoginPw()));

        Member member = memberRepository.save(newMember);

        Parent parent = Parent.builder()
                .member(member)
                .build();
        Parent savedParent = parentRepository.save(parent);
        return member.getName();
    }

    private String makeUserPhone(String phoneString) {
        String[] phone = phoneString.split("-");

        return phone[0] + phone[1] + phone[2];
    }
}
