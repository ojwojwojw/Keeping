package com.keeping.notiservice.domain.noti.repository;

import com.keeping.notiservice.domain.noti.Noti;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotiRepository extends JpaRepository<Long, Noti> {
}
