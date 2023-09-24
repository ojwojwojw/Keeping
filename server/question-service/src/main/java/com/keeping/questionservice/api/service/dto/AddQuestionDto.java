package com.keeping.questionservice.api.service.dto;

import com.keeping.questionservice.api.controller.request.AddQuestionRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

@Data
@NoArgsConstructor
public class AddQuestionDto {

    private String childMemberKey;
    private String content;

    @Builder
    public AddQuestionDto(String childMemberKey, String content) {
        this.childMemberKey = childMemberKey;
        this.content = content;
    }

    public static AddQuestionDto toDto(AddQuestionRequest request) {
        return AddQuestionDto.builder()
                .childMemberKey(request.getChildMemberKey())
                .content(request.getContent())
                .build();
    }
}
