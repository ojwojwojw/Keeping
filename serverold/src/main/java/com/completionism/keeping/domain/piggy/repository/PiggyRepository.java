package com.completionism.keeping.domain.piggy.repository;

import com.completionism.keeping.domain.piggy.Piggy;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PiggyRepository extends JpaRepository<Piggy, Long> {
}
