package com.keeping.missionservice.api.controller.mission;

import com.keeping.missionservice.api.ApiResponse;
import com.keeping.missionservice.api.controller.mission.response.AccountResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "bank-service", url = "http://j9c207.p.ssafy.io:8000")
public interface BankFeignClient {

    /**
     * 부모 잔액 조회
     * @param memberKey 부모 사용자 key
     * @return 잔액
     */
    @GetMapping("/bank-service/api/{member_key}/account/balance")
    ApiResponse<AccountResponse> getAccountBalanceFromParent(@PathVariable("member_key") String memberKey);

    @GetMapping("/bank-service/api/{member_key}/account-history/transfer/{money}")
    ApiResponse<Void> transferMoneyForMission(@PathVariable("member_key") String memberKey, @PathVariable("money") int money);
    
}
