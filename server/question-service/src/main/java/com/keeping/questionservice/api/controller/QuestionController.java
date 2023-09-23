package com.keeping.questionservice.api.controller;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.request.AddAnswerRequest;
import com.keeping.questionservice.api.controller.request.AddQuestionRequest;
import com.keeping.questionservice.api.controller.response.QuestionResponse;
import com.keeping.questionservice.api.controller.response.QuestionResponseList;
import com.keeping.questionservice.api.controller.response.TodayQuestionResponse;
import com.keeping.questionservice.api.service.QuestionService;
import com.keeping.questionservice.api.service.dto.AddAnswerDto;
import com.keeping.questionservice.api.service.dto.AddQuestionDto;
import com.keeping.questionservice.global.exception.AlreadyExistException;
import com.keeping.questionservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/question-service/api/{memberKey}")
@Slf4j
public class QuestionController {

    private final QuestionService questionService;

    @PostMapping("/answer")
    public ApiResponse<Long> addAnswer(
            @RequestBody AddAnswerRequest request,
            @PathVariable String memberKey
    ) {
        try {
            Long questionId = questionService.addAnswer(memberKey, AddAnswerDto.toDto(request));
            return ApiResponse.ok(questionId);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage());
        }
    }

    @GetMapping("/questions/today")
    public ApiResponse<TodayQuestionResponse> getQuestionToday(@PathVariable String memberKey){
        try {
            TodayQuestionResponse todayQuestionResponse = questionService.showQuestionToday(memberKey);
            return ApiResponse.ok(todayQuestionResponse);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage());
        }
    }


    @GetMapping("/questions")
    public ApiResponse<QuestionResponseList> getQuestionList(@PathVariable String memberKey) {
        return ApiResponse.ok(questionService.showQuestion(memberKey));
    }

    @GetMapping("/questions/{question_id}")
    public ApiResponse<QuestionResponse> getQuestion(
            @PathVariable String memberKey,
            @PathVariable(name = "question_id") Long questionId
    ) {

        try {
            QuestionResponse questionResponse = questionService.showDetailQuestion(memberKey, questionId);
            return ApiResponse.ok(questionResponse);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage());
        }

    }


    @PostMapping
    public ApiResponse<Long> addQuestion(
            @RequestBody @Valid AddQuestionRequest request,
            @PathVariable String memberKey
    ) {

        try {
            Long questionId = questionService.addQuestion(memberKey, AddQuestionDto.toDto(request));
            return ApiResponse.ok(questionId);
        } catch (AlreadyExistException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage());
        }
    }
}
