package com.keeping.questionservice.api.controller.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

@Data
@NoArgsConstructor
public class AddQuestionRequest {
    
    @NotBlank
    private String childMemberKey;
    @NotBlank
    private String content;


    @Builder
    private AddQuestionRequest(String childMemberKey, String content) {
        this.childMemberKey = childMemberKey;
        this.content = content;
    }
}
