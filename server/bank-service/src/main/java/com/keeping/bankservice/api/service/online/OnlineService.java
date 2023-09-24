package com.keeping.bankservice.api.service.online;

import com.keeping.bankservice.api.service.online.dto.AddOnlineDto;
import com.keeping.bankservice.api.service.online.dto.ApproveOnlineDto;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public interface OnlineService {
    Long addOnline(String childKey, AddOnlineDto dto);
    void approveOnline(String memberKey, ApproveOnlineDto dto);
}
