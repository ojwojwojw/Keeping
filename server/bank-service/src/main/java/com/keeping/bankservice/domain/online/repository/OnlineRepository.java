package com.keeping.bankservice.domain.online.repository;

import com.keeping.bankservice.domain.online.Online;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OnlineRepository extends JpaRepository<Online, Long> {
}
