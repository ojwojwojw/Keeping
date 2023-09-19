package com.keeping.bankservice.api.service.piggy_history;

import com.keeping.bankservice.api.service.piggy_history.dto.AddPiggyHistoryDto;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public interface PiggyHistoryService {
    Long addPiggyHistory(String memberKey, AddPiggyHistoryDto dto);
}
