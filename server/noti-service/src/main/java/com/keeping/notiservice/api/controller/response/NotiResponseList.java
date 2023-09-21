package com.keeping.notiservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class NotiResponseList {

    List<NotiResponse> notiResponseList;

    @Builder
    public NotiResponseList(List<NotiResponse> notiResponseList) {
        this.notiResponseList = notiResponseList;
    }
}
