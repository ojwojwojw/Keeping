package com.keeping.bankservice.api.service.piggy;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.bankservice.api.service.piggy.dto.AddPiggyDto;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;

@Transactional
public interface PiggyService {
    Long addPiggy(String memberKey, AddPiggyDto dto) throws IOException;
}
