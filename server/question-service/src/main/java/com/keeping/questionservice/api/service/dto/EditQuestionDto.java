package com.keeping.questionservice.api.service.dto;

import com.keeping.questionservice.api.controller.request.EditQuestionRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class EditQuestionDto {

    private Long questionId;
    private String childMemberKey;
    private String content;


    @Builder
    public EditQuestionDto(Long questionId, String childMemberKey, String content) {
        this.questionId = questionId;
        this.childMemberKey = childMemberKey;
        this.content = content;
    }

    public static EditQuestionDto toDto(EditQuestionRequest request) {
        return EditQuestionDto.builder()
                .questionId(request.getQuestionId())
                .childMemberKey(request.getChildMemberKey())
                .content(request.getContent())
                .build();
    }
}
