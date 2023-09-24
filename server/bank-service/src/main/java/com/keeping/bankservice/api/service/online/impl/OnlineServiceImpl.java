package com.keeping.bankservice.api.service.online.impl;

import com.keeping.bankservice.api.service.online.OnlineService;
import com.keeping.bankservice.api.service.online.dto.AddOnlineDto;
import com.keeping.bankservice.domain.online.Online;
import com.keeping.bankservice.domain.online.repository.OnlineQueryRepository;
import com.keeping.bankservice.domain.online.repository.OnlineRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import static com.keeping.bankservice.global.common.Approve.WAIT;

@Service
@Transactional
@RequiredArgsConstructor
public class OnlineServiceImpl implements OnlineService {

    private final OnlineRepository onlineRepository;
    private final OnlineQueryRepository onlineQueryRepository;

    @Override
    public Long addOnline(String childKey, AddOnlineDto dto) {
        Online online = Online.toOnline(childKey, dto.getProductName(), dto.getUrl(), dto.getContent(), dto.getTotalMoney(), dto.getChildMoney(), null, WAIT);
        Online saveOnline = onlineRepository.save(online);

        return saveOnline.getId();
    }
}
