package com.keeping.missionservice.domain.mission.repository;

import com.keeping.missionservice.domain.mission.Mission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MissionRepository extends JpaRepository<Mission, Long> {

    Optional<Long> findByIdAndChildKey(Long id, String childKey);
}
