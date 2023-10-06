package com.keeping.questionservice.api.service.dto;

import com.keeping.questionservice.api.controller.request.AddAnswerRequest;
import com.keeping.questionservice.domain.MemberType;
import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
public class AddAnswerDto {


    private boolean isParent;

    private Long questionId;
    
    private String answer;


    @Builder
    public AddAnswerDto(boolean isParent, Long questionId, String answer) {
        this.isParent = isParent;
        this.questionId = questionId;
        this.answer = answer;
    }

    public static AddAnswerDto toDto(AddAnswerRequest request) {
        return AddAnswerDto.builder()
                .isParent(request.isParent())
                .questionId(request.getQuestionId())
                .answer(request.getAnswer())
                .build();
    }
}
