package com.keeping.memberservice.domain.repository;

import com.keeping.memberservice.domain.Member;
import com.keeping.memberservice.domain.Parent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ParentRepository extends JpaRepository<Parent, Long> {

    Optional<Parent> findByMember(Member member);
}
