package com.keeping.questionservice.api.controller;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.request.*;
import com.keeping.questionservice.api.controller.response.QuestionCommentResponse;
import com.keeping.questionservice.api.controller.response.QuestionResponseList;
import com.keeping.questionservice.api.controller.response.TodayQuestionCommentResponse;
import com.keeping.questionservice.api.service.QuestionService;
import com.keeping.questionservice.api.service.dto.*;
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

    @GetMapping("/questions/today")
    public ApiResponse<List<TodayQuestionCommentResponse>> getQuestionToday(@PathVariable String memberKey){
        try {
            List<TodayQuestionCommentResponse> todayQuestionCommentRespons = questionService.showQuestionToday(memberKey);
            return ApiResponse.ok(todayQuestionCommentRespons);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage());
        }
    }


    @GetMapping("/questions")
    public ApiResponse<QuestionResponseList> getQuestionList(@PathVariable String memberKey) {
        return ApiResponse.ok(questionService.showQuestion(memberKey));
    }

    @GetMapping("/questions/{question_id}")
    public ApiResponse<QuestionCommentResponse> getQuestion(
            @PathVariable String memberKey,
            @PathVariable(name = "question_id") Long questionId
    ) {

        try {
            QuestionCommentResponse questionCommentResponse = questionService.showDetailQuestion(memberKey, questionId);
            return ApiResponse.ok(questionCommentResponse);
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

    @PostMapping("/comment")
    public ApiResponse<Long> addComment(
            @RequestBody AddCommentRequest request,
            @PathVariable String memberKey
            ) {

        try {
            Long questionId = questionService.addComment(memberKey, AddCommentDto.toDto(request));
            return ApiResponse.ok(questionId);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage());
        }
    }

    @PatchMapping
    public ApiResponse<Void> editQuestion(
            @RequestBody @Valid EditQuestionRequest request,
            @PathVariable String memberKey
    ) {

        try {
            questionService.editQuestion(memberKey, EditQuestionDto.toDto(request));
            return ApiResponse.ok(null);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage());
        }
    }

    @PatchMapping("/comment")
    public ApiResponse<Void> editComment(
            @RequestBody @Valid EditCommentRequest request,
            @PathVariable String memberKey
            ) {

        try {
            questionService.editComment(memberKey, EditCommentDto.toDto(request));
            return ApiResponse.ok(null);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage());
        }
    }

    @DeleteMapping("/comment/{comment_id}")
    public ApiResponse<Void> removeComment(
            @PathVariable String memberKey,
            @PathVariable(name = "comment_id") Long commentId
    ) {
        try {
            questionService.removeComment(memberKey, commentId);
            return ApiResponse.ok(null);
        } catch (NotFoundException e) {
            return ApiResponse.of(Integer.parseInt(e.getResultCode()), e.getHttpStatus(), e.getResultMessage());
        }
    }


}
