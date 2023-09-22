package com.keeping.memberservice.api.controller.response;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
public class LoginMember {

    private boolean isParent;
    private String name;
    private String profileImage;
    private List<ChildrenResponse> childrenList;

    @Builder
    public LoginMember(boolean isParent, String name, String profileImage, List<ChildrenResponse> childrenList) {
        this.isParent = isParent;
        this.name = name;
        this.profileImage = profileImage;
        this.childrenList = childrenList;
    }
}
