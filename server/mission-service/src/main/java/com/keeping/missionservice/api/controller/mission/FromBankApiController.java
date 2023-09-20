package com.keeping.missionservice.api.controller.mission;

import com.keeping.missionservice.api.controller.mission.response.AccountResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name = "bank-service")
public interface FromBankApiController {

    /**
     * 부모 잔액 조회
     * @param memberKey 부모 사용자 key
     * @return 잔액
     */
    @GetMapping("/account-balance/{memberKey}")
    AccountResponse getAccountBalanceFromParent(@PathVariable("memberkey") String memberKey);
    
}
