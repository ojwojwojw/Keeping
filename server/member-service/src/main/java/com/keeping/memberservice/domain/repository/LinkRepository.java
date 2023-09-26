package com.keeping.memberservice.domain.repository;

import com.keeping.memberservice.domain.Child;
import com.keeping.memberservice.domain.Link;
import com.keeping.memberservice.domain.Parent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LinkRepository extends JpaRepository<Link, Long> {
    Optional<Link> findByParentAndChild(Parent parent, Child child);
}
