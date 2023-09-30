package com.keeping.notiservice.api.service;

import com.keeping.notiservice.api.controller.request.QuestionNotiRequestList;
import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.api.service.dto.AddNotiDto;
import com.keeping.notiservice.api.service.dto.SendNotiDto;

import java.util.List;

public interface NotiService {

    public void sendNotis(QuestionNotiRequestList requestList);

    public Long sendNoti(String memberKey, SendNotiDto dto);
    
    public Long addNoti(AddNotiDto dto);

    public List<NotiResponse> showNoti(String memberKey);

    public List<NotiResponse> showNotiByType(String memberKey, String notiType);
}
