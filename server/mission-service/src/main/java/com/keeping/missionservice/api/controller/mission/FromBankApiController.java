package com.keeping.missionservice.api.controller.mission;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "bank-service")
public class FromBankApiController {
    
}
