package com.keeping.memberservice.domain.repository;

import com.keeping.memberservice.domain.Child;
import com.keeping.memberservice.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ChildRepository extends JpaRepository<Child, Long> {
    Optional<Child> findByMember(Member member);
}
