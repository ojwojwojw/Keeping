package com.completionism.keeping.api.service.member;

import com.completionism.keeping.api.service.member.dto.AddParentDto;
import com.completionism.keeping.domain.member.repository.MemberRepository;
import com.completionism.keeping.domain.member.repository.ParentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
@Transactional
@Slf4j
public class MemberService {

    private final ParentRepository parentRepository;
    private final MemberRepository memberRepository;

    public String addParent(AddParentDto dto){
        return "";
    }
}
