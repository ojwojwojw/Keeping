package com.keeping.bankservice.api.service.online;

import com.keeping.bankservice.api.controller.online.response.ShowOnlineResponse;
import com.keeping.bankservice.api.service.online.dto.AddOnlineDto;
import com.keeping.bankservice.api.service.online.dto.ApproveOnlineDto;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional
public interface OnlineService {
    Long addOnline(String childKey, AddOnlineDto dto);
    void approveOnline(String memberKey, ApproveOnlineDto dto);
    List<ShowOnlineResponse> showOnline(String memberKey, String targetKey);

}
