package com.keeping.bankservice.api.service.online;

import com.keeping.bankservice.api.controller.online.response.ShowOnlineResponse;
import com.keeping.bankservice.api.service.online.dto.AddOnlineDto;
import com.keeping.bankservice.api.service.online.dto.ApproveOnlineDto;
import com.keeping.bankservice.global.common.Approve;
import org.springframework.transaction.annotation.Transactional;

import java.net.URISyntaxException;
import java.util.List;

@Transactional
public interface OnlineService {
    Long addOnline(String childKey, AddOnlineDto dto);
    void approveOnline(String memberKey, ApproveOnlineDto dto) throws URISyntaxException;
    List<ShowOnlineResponse> showOnline(String memberKey, String targetKey);
    List<ShowOnlineResponse> showTypeOnline(String memberKey, String targetKey, Approve approve);
    ShowOnlineResponse showDetailOnline(String memberKey, String targetKey, Long onlineId);
}
