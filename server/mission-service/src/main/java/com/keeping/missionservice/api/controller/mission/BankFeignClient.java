package com.keeping.missionservice.api.controller.mission;

import com.keeping.missionservice.api.ApiResponse;
import com.keeping.missionservice.api.controller.mission.response.AccountResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "/bank-service/{member_key}")
public interface BankFeignClient {

    /**
     * 부모 잔액 조회
     * @param memberKey 부모 사용자 key
     * @return 잔액
     */
    @GetMapping("/account-balance")
    ApiResponse<AccountResponse> getAccountBalanceFromParent(@PathVariable("member_key") String memberKey);

    @GetMapping("/transfer/{money}")
    ApiResponse<Void> transferMoneyForMission(@PathVariable("member_key") String memberKey, @PathVariable("money") int money);
    
}
