package com.keeping.bankservice.domain.regular_allowance.repository;

import com.keeping.bankservice.domain.regular_allowance.RegularAllowance;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RegularAllowanceRepository extends JpaRepository<RegularAllowance, Long> {
    List<RegularAllowance> findByDay(int day);
}
