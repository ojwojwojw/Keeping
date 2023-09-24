package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

@Data
public class ChildrenResponse {

    private String memberKey;
    private String name;
    private String profileImage;

    @Builder
    private ChildrenResponse(String memberKey, String name, String profileImage) {
        this.memberKey = memberKey;
        this.name = name;
        this.profileImage = profileImage;
    }
}
