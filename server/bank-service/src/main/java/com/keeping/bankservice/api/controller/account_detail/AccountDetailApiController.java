package com.keeping.bankservice.api.controller.account_detail;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.account_detail.request.AddAccountDetailRequest;
import com.keeping.bankservice.api.service.account_detail.AccountDetailService;
import com.keeping.bankservice.api.service.account_detail.dto.AddAccountDetailDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/account-detail")
public class AccountDetailApiController {

    private final AccountDetailService accountDetailService;

    @PostMapping("/{member-key}")
    public ApiResponse<Void> addAccountDetail(@PathVariable("member-key") String memberKey, @RequestBody AddAccountDetailRequest request) {
        log.debug("AddAccountDetailRequest={}", request);

        AddAccountDetailDto dto = AddAccountDetailDto.toDto(request);

//        try {
//            accountDetailService.addAccountDetail(memberKey, dto);
//        }

        return null;
    }

}
