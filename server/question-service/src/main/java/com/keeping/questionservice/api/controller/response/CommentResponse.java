package com.keeping.questionservice.api.controller.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class CommentResponse {

    private Long commentId;
    private String memberKey;
    private String content;
    private LocalDateTime createdDate;

    @Builder
    public CommentResponse(Long commentId, String memberKey, String content, LocalDateTime createdDate) {
        this.commentId = commentId;
        this.memberKey = memberKey;
        this.content = content;
        this.createdDate = createdDate;
    }
}
