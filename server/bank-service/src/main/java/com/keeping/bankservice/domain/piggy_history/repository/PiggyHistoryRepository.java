package com.keeping.bankservice.domain.piggy_history.repository;

import com.keeping.bankservice.domain.piggy_history.PiggyHistory;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PiggyHistoryRepository extends JpaRepository<PiggyHistory, Long> {
}
