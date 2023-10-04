package com.keeping.bankservice.api.controller.piggy_history;

import com.keeping.bankservice.api.ApiResponse;
import com.keeping.bankservice.api.controller.piggy_history.response.ShowPiggyHistoryResponse;
import com.keeping.bankservice.api.service.piggy_history.PiggyHistoryService;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bank-service/api/{member-key}/piggy-history")
public class PiggyHistoryApiController {

    private final PiggyHistoryService piggyHistoryService;

    @GetMapping("/{target-key}/{piggy-id}")
    public ApiResponse<List<ShowPiggyHistoryResponse>> showPiggyHistory(@PathVariable("member-key") String memberKey, @PathVariable("target-key") String targetKey, @PathVariable("piggy-id") Long piggyId) {
        log.debug("ShowPiggyHistory");

        try {
            List<ShowPiggyHistoryResponse> response = piggyHistoryService.showPiggyHistory(memberKey, targetKey, piggyId);
            return ApiResponse.ok(response);
        } catch (NotFoundException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        } catch (NoAuthorizationException e) {
            return ApiResponse.of(1, e.getHttpStatus(), e.getResultMessage(), null);
        }

    }
}
