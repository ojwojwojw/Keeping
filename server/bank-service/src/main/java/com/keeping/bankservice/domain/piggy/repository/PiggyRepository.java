package com.keeping.bankservice.domain.piggy.repository;

import com.keeping.bankservice.domain.piggy.Piggy;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PiggyRepository extends JpaRepository<Piggy, Long> {
    Optional<Piggy> findByAccountNumber(String accountNumber);
}
