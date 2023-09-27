package com.keeping.memberservice.api.service.member;

import com.keeping.memberservice.api.controller.response.*;
import com.keeping.memberservice.api.service.AuthService;
import com.keeping.memberservice.api.service.member.dto.AddMemberDto;
import com.keeping.memberservice.domain.Child;
import com.keeping.memberservice.domain.Link;
import com.keeping.memberservice.domain.Member;
import com.keeping.memberservice.domain.Parent;
import com.keeping.memberservice.domain.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@RequiredArgsConstructor
@Service
@Transactional
@Slf4j
public class MemberService implements UserDetailsService {
    private final ParentRepository parentRepository;

    private final ChildRepository childRepository;
    private final MemberRepository memberRepository;
    private final LinkRepository linkRepository;
    private final LinkQueryRepository linkQueryRepository;

    private final BCryptPasswordEncoder passwordEncoder;
    private final AuthService authService;

    /**
     * 자녀 키 목록 출력
     *
     * @param memberKey
     * @return
     */
    public List<ChildKeyResponse> getChildKeyList(String memberKey) {
        return linkQueryRepository.getChildKeyList(memberKey);
    }

    /**
     * 타입 체크
     *
     * @param memberKey
     * @param type
     * @return
     */
    public boolean typeCheck(String memberKey, String type) {
        Member member = memberRepository.findByMemberKey(memberKey).orElseThrow(() ->
                new NoSuchElementException("등록되지 않은 사용자입니다."));
        if (type.equals("PARENT")) {
            return parentRepository.findByMember(member).isPresent();
        } else {
            return childRepository.findByMember(member).isPresent();
        }
    }

    /**
     * 부모 자녀 관계인지 확인
     *
     * @return
     */
    public RelationshipCheckResponse relationCheck(String parentKey, String childKey) {
        Member parentMember = memberRepository.findByMemberKey(parentKey).orElseThrow(() -> new NoSuchElementException("잘못된 부모 회원키입니다."));
        Member childMember = memberRepository.findByMemberKey(childKey).orElseThrow(() -> new NoSuchElementException("잘못된 자녀 회원키입니다."));

        Parent parent = parentRepository.findByMember(parentMember).orElseThrow(() -> new NoSuchElementException("부모로 등록된 회원이 아닙니다."));
        Child child = childRepository.findByMember(childMember).orElseThrow(() -> new NoSuchElementException("부모로 등록된 회원이 아닙니다."));

        Optional<Link> findLink = linkRepository.findByParentAndChild(parent, child);

        return RelationshipCheckResponse.builder()
                .isParentialRelationship(findLink.isPresent())
                .build();
    }

    /**
     * 부모인지, 자녀인지 확인
     *
     * @param memberKey
     * @return true = 부모
     */
    public boolean isParent(String memberKey) {
        Member member = memberRepository.findByMemberKey(memberKey).orElseThrow(() ->
                new NoSuchElementException("등록되지 않은 사용자입니다."));
        Optional<Parent> parent = parentRepository.findByMember(member);
        return parent.isPresent();
    }

    /**
     * 로그인 후 정보요청
     *
     * @param memberKey 로그인한 멤버 키
     * @return 로그인 유저 정보
     */
    public LoginMember getLoginUser(String memberKey) {
        Member findMember = memberRepository.findByMemberKey(memberKey).orElseThrow(() -> new NoSuchElementException("등록되지 않은 사용자입니다."));
        Optional<Parent> findParent = parentRepository.findByMember(findMember);
        boolean isParent = findParent.isPresent();
        LoginMember loginMember = null;
        if (isParent) {
            // 부모일 때
            // TODO: 2023-09-22 자녀 가져오기
            Parent parent = findParent.get();
            List<ChildrenResponse> childList = linkQueryRepository.getChildList(parent);
            loginMember = LoginMember.builder()
                    .isParent(true)
                    .name(findMember.getName())
                    .profileImage(findMember.getProfileImage())
                    .childrenList(childList)
                    .build();
        } else {
            // 자녀일 때
            loginMember = getChildResponse(findMember);
        }
        return loginMember;
    }

    /**
     * @param loginId 로그인 아이디
     * @return 아이디 중복체크 결과(true = 사용 가능)
     */
    public boolean idDuplicateCheck(String loginId) {
        // 아이디 중복 검사
        Optional<Member> findMember = memberRepository.findByLoginId(loginId);

        return findMember.isEmpty();
    }

    public String addChild(AddMemberDto dto, String parentPhone) {
        // 아이디 중복 검사
        Optional<Member> findMember = memberRepository.findByLoginId(dto.getLoginId());

        if (findMember.isPresent()) {
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }

        //번호 인증 검사
        if (!authService.joinUserConfirm(makeUserPhone(dto.getPhone()))) {
            throw new IllegalArgumentException("문자 인증이 완료되지 않았습니다.");
        }
        //번호 인증 검사
        if (!authService.joinUserConfirm(makeUserPhone(parentPhone))) {
            throw new IllegalArgumentException("부모님의 문자 인증이 완료되지 않았습니다.");
        }

        //가입
        dto.setMemberKey(UUID.randomUUID().toString());
        Member newMember = dto.toEntity(passwordEncoder.encode(dto.getLoginPw()));

        Member member = memberRepository.save(newMember);

        Child child = Child.builder()
                .member(member)
                .build();
        Child savedChild = childRepository.save(child);
        return member.getName();
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

    private LoginMember getChildResponse(Member findMember) {
        return LoginMember.builder()
                .isParent(false)
                .name(findMember.getName())
                .profileImage(findMember.getProfileImage())
                .build();
    }

    public LinkResultResponse linkMember(String memberKey, String partner, String relation) {
        Member myMember = memberRepository.findByMemberKey(memberKey).orElseThrow(() -> new NoSuchElementException("잘못된 요청입니다."));
        Member yourMember = memberRepository.findByMemberKey(partner).orElseThrow(() -> new NoSuchElementException("잘못된 요청입니다."));
        Parent parent = null;
        Child child = null;
        if (relation.equals("parent")) {
            parent = parentRepository.findByMember(yourMember).orElseThrow(() -> new NoSuchElementException("잘못된 요청입니다."));
            child = childRepository.findByMember(myMember).orElseThrow(() -> new NoSuchElementException("잘못된 요청입니다."));
        } else {
            parent = parentRepository.findByMember(myMember).orElseThrow(() -> new NoSuchElementException("잘못된 요청입니다."));
            child = childRepository.findByMember(yourMember).orElseThrow(() -> new NoSuchElementException("잘못된 요청입니다."));
        }

        Link newLink = Link.builder().parent(parent).child(child).build();
        Link savedLink = linkRepository.save(newLink);

        return LinkResultResponse.builder()
                .partner(yourMember.getName())
                .relation(relation)
                .build();
    }

    public void setFcmToken(String memberKey, String fcmToken) {
        Member member = memberRepository.findByMemberKey(memberKey).orElseThrow(() -> new NoSuchElementException("없는 회원입니다."));
        member.setFcmToken(fcmToken);
    }
}
