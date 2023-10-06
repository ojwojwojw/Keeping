package com.keeping.missionservice.api.controller.mission;

import com.keeping.missionservice.api.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "bank-service-demo")
public interface BankFeignClient {

    /**
     * 부모 잔액 조회
     * @param memberKey 부모 사용자 key
     * @return 잔액
     */
    @GetMapping("/bank-service/api/{member-key}/account/balance")
    ApiResponse<Long> getAccountBalanceFromParent(@PathVariable("member-key") String memberKey);

    @GetMapping("/bank-service/api/{member-key}/account-history/transfer/{money}")
    ApiResponse<Void> transferMoneyForMission(@PathVariable("member-key") String memberKey, @PathVariable("money") int money);
    
}
