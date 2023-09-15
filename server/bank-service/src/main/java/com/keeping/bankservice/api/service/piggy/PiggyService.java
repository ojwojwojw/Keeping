package com.keeping.bankservice.api.service.piggy;

import com.keeping.bankservice.api.controller.piggy.response.ShowPiggyResponse;
import com.keeping.bankservice.api.service.account.dto.SavingPiggyDto;
import com.keeping.bankservice.api.service.piggy.dto.AddPiggyDto;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;

@Transactional
public interface PiggyService {
    Long addPiggy(String memberKey, AddPiggyDto dto) throws IOException;
    List<ShowPiggyResponse> showPiggy(String memberKey) throws IOException;
    void savingPiggy(String memberKey, SavingPiggyDto dto);
}
