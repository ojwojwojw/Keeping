package com.keeping.bankservice.api.service.piggy_history.impl;

import com.keeping.bankservice.api.controller.piggy_history.response.ShowPiggyHistoryResponse;
import com.keeping.bankservice.api.service.piggy.PiggyService;
import com.keeping.bankservice.api.service.piggy_history.PiggyHistoryService;
import com.keeping.bankservice.api.service.piggy_history.dto.AddPiggyHistoryDto;
import com.keeping.bankservice.domain.piggy.Piggy;
import com.keeping.bankservice.domain.piggy.repository.PiggyRepository;
import com.keeping.bankservice.domain.piggy_history.PiggyHistory;
import com.keeping.bankservice.domain.piggy_history.repository.PiggyHistoryQueryRepository;
import com.keeping.bankservice.domain.piggy_history.repository.PiggyHistoryRepository;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import com.keeping.bankservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class PiggyHistoryServiceImpl implements PiggyHistoryService {

    private final PiggyRepository piggyRepository;
    private final PiggyHistoryRepository piggyHistoryRepository;
    private final PiggyHistoryQueryRepository piggyHistoryQueryRepository;

    @Override
    public Long addPiggyHistory(String memberKey, AddPiggyHistoryDto dto) {
        String lastSavingHistoryName = piggyHistoryQueryRepository.lastSavingHistoryName(dto.getPiggy());

        String name = null;
        if(lastSavingHistoryName == null) {
            name = "0";
        }
        else {
            name = Integer.toString(Integer.parseInt(lastSavingHistoryName) + 1);
        }

        PiggyHistory piggyHistory = PiggyHistory.toPiggyHistory(dto.getPiggy(), name, dto.getMoney(), dto.getBalance());
        PiggyHistory savePiggyHistory = piggyHistoryRepository.save(piggyHistory);

        return savePiggyHistory.getId();
    }

    @Override
    public List<ShowPiggyHistoryResponse> showPiggyHistory(String memberKey, Long piggyId) {
        Piggy piggy = piggyRepository.findById(piggyId)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 저금통이 존재하지 않습니다."));

        if (!piggy.getChildKey().equals(memberKey)) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "접근 권한이 없습니다.");
        }


        List<ShowPiggyHistoryResponse> showPiggyHistory = piggyHistoryQueryRepository.showPiggyHistory(piggyId);

        return showPiggyHistory;
    }
}
