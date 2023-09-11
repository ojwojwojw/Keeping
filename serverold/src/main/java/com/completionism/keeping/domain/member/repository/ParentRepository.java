package com.completionism.keeping.domain.member.repository;

import com.completionism.keeping.domain.member.Parent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ParentRepository extends JpaRepository<Parent, Long> {
}
