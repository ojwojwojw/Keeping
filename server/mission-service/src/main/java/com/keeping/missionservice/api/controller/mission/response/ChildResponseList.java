package com.keeping.missionservice.api.controller.mission.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class ChildResponseList {
    
    public List<ChildResponse> childResponseList;

    @Builder
    public ChildResponseList(List<ChildResponse> childResponseList) {
        this.childResponseList = childResponseList;
    }
}