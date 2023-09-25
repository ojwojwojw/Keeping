package com.keeping.bankservice.api.service.piggy_history;

import com.keeping.bankservice.api.controller.piggy_history.response.ShowPiggyHistoryResponse;
import com.keeping.bankservice.api.service.piggy_history.dto.AddPiggyHistoryDto;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional
public interface PiggyHistoryService {
    Long addPiggyHistory(String memberKey, AddPiggyHistoryDto dto);
    List<ShowPiggyHistoryResponse> showPiggyHistory(String memberKey, Long piggyId);
}
