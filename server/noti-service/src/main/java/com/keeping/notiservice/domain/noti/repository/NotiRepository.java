package com.keeping.notiservice.domain.noti.repository;

import com.keeping.notiservice.domain.noti.Noti;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotiRepository extends JpaRepository<Noti, Long> {
}
