package com.keeping.questionservice.api.service.dto;

import com.keeping.questionservice.api.controller.request.EditCommentRequest;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class EditCommentDto {

    private Long questionId;

    private Long commentId;

    private String content;

    @Builder
    public EditCommentDto(Long questionId, Long commentId, String content) {
        this.questionId = questionId;
        this.commentId = commentId;
        this.content = content;
    }

    public static EditCommentDto toDto(EditCommentRequest request) {
        return EditCommentDto.builder()
                .questionId(request.getQuestionId())
                .commentId(request.getCommentId())
                .content(request.getContent())
                .build();
    }
}
