package com.keeping.notiservice.api.service;

import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.api.service.dto.AddNotiDto;
import com.keeping.notiservice.api.service.dto.SendNotiDto;

import java.util.List;

public interface NotiService {

    public Long sendNoti(SendNotiDto dto);
    
    public Long addNoti(AddNotiDto dto);

    public List<NotiResponse> showNoti(String memberKey);
}
