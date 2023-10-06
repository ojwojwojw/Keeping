package com.keeping.openaiservice.api.controller;

import com.keeping.openaiservice.api.ApiResponse;
import com.keeping.openaiservice.api.controller.response.TransactionResponseList;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@FeignClient(name = "bank-service-demo")
public interface BankFeignClient {

    @GetMapping("/bank-service/server/account-history/question")
    ApiResponse<List<TransactionResponseList>> getTransactionData();
}
