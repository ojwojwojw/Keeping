package com.keeping.questionservice.api.service.dto;

import com.keeping.questionservice.api.controller.request.AddCommentRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@NoArgsConstructor
public class AddCommentDto {

    private Long questionId;

    private String content;

    @Builder
    public AddCommentDto(Long questionId, String content) {
        this.questionId = questionId;
        this.content = content;
    }

    public static AddCommentDto toDto(AddCommentRequest request) {
        return AddCommentDto.builder()
                .questionId(request.getQuestionId())
                .content(request.getContent())
                .build();
    }
}
