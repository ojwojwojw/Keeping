package com.completionism.keeping.domain.mission;

public enum Completed {
    CREATE_WAIT,    // 자녀가 요청한 미션 등록 승인 대기
    YET,            // 자녀가 아직 미션 수행하지 않음
    FINISH_WAIT,    // 미션 완료 승인 대기
    FINISH          // 부모가 미션 완료 승인
}
