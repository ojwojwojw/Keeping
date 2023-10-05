package com.keeping.bankservice.api.service.piggy;

import com.keeping.bankservice.api.controller.piggy.response.SavingPiggyResponse;
import com.keeping.bankservice.api.controller.piggy.response.ShowPiggyResponse;
import com.keeping.bankservice.api.service.account.dto.SavingPiggyDto;
import com.keeping.bankservice.api.service.piggy.dto.AddPiggyDto;
import com.keeping.bankservice.domain.piggy.Piggy;
import org.springframework.transaction.annotation.Transactional;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.List;

@Transactional
public interface PiggyService {
    Long addPiggy(String memberKey, AddPiggyDto dto) throws IOException;
    List<ShowPiggyResponse> showPiggy(String memberKey, String targetKey) throws IOException;
    ShowPiggyResponse showDetailPiggy(String memberKey, String targetKey, Long piggyId) throws IOException;
    SavingPiggyResponse savingPiggy(String memberKey, SavingPiggyDto dto) throws URISyntaxException, IOException;
    Piggy isValidPiggy(String memberKey, Long piggyId);
}
