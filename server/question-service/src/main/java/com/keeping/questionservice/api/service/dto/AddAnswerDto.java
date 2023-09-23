package com.keeping.questionservice.api.service.dto;

import com.keeping.questionservice.api.controller.request.AddAnswerRequest;
import com.keeping.questionservice.domain.MemberType;
import lombok.Builder;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
public class AddAnswerDto {


    private Long questionId;
    
    private String answer;
    
    private boolean isCreated;

    @Builder
    public AddAnswerDto(Long questionId, String answer, boolean isCreated) {
        this.questionId = questionId;
        this.answer = answer;
        this.isCreated = isCreated;
    }

    public static AddAnswerDto toDto(AddAnswerRequest request) {
        return AddAnswerDto.builder()
                .questionId(request.getQuestionId())
                .answer(request.getAnswer())
                .isCreated(request.isCreated())
                .build();
    }
}
