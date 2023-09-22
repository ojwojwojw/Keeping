package com.keeping.bankservice.api.controller.account_history;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.account_history.request.AddAccountHistoryRequest;
import com.keeping.bankservice.api.controller.account_history.response.ShowAccountHistoryResponse;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/account-history")
public class AccountHistoryApiController {

    private final AccountHistoryService accountHistoryService;

    // TODO: service단에 memberKey 넘겨서 검증하는 과정 필요
    @PostMapping("/{member-key}")
    public ApiResponse<Void> addAccountHistory(@PathVariable("member-key") String memberKey, @RequestBody AddAccountHistoryRequest request) {
        log.debug("AddAccountHistory={}", request);

        AddAccountHistoryDto dto = AddAccountHistoryDto.toDto(request);

//        try {
//            Long accountHistoryId = accountHistoryService.addAccountHistory(dto);
//        }

        return null;
    }

    @GetMapping("/account/detail/{member-key}")
    public ApiResponse<ShowAccountHistoryResponse> showAccountHistory(@PathVariable("member-key") String memberKey) {
        log.debug("ShowAccountHistory");

        return null;
    }
}
