package com.keeping.bankservice.domain.allowance.repository;

import com.keeping.bankservice.domain.allowance.Allowance;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AllowanceRepository extends JpaRepository<Allowance, Long> {
}
