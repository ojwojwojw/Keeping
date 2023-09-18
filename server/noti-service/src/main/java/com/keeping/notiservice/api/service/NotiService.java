package com.keeping.notiservice.api.service;

import com.keeping.notiservice.api.controller.response.NotiResponse;
import com.keeping.notiservice.api.service.dto.AddNotiDto;

import java.util.List;

public interface NotiService {
    
    public Long addNoti(AddNotiDto dto);

    public List<NotiResponse> showNoti(String memberKey);
}
