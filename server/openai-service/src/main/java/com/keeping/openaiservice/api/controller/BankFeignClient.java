package com.keeping.openaiservice.api.controller;

import com.keeping.openaiservice.api.ApiResponse;
import com.keeping.openaiservice.api.controller.request.TransactionTotalList;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "bank-service")
public interface BankFeignClient {

    @GetMapping("/bank-service/api/transaction-question")
    ApiResponse<TransactionTotalList> getTransactionData();
}
