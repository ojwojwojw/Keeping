package com.keeping.bankservice.domain.piggy.repository;

import com.keeping.bankservice.domain.piggy.Piggy;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PiggyRepository extends JpaRepository<Piggy, Long> {
}
