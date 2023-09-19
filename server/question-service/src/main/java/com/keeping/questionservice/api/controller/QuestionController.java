package com.keeping.questionservice.api.controller;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.request.AddAnswerRequest;
import com.keeping.questionservice.api.controller.request.AddQuestionRequest;
import com.keeping.questionservice.api.controller.response.QuestionResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/question-service/{memberKey}")
@Slf4j
public class QuestionController {


    @PostMapping("/{questionId}/answer")
    public ApiResponse<String> addAnswer(@RequestBody AddAnswerRequest request,
                                         @PathVariable String memberKey,
                                         @PathVariable String questionId) {
        // TODO: 2023-09-14 질문 답변 등록
        return ApiResponse.ok("");
    }

    @GetMapping("/questions")
    public ApiResponse<List<QuestionResponse>> getQuestionList(@PathVariable String memberKey) {
        // TODO: 2023-09-14 질문 목록 조회
        return ApiResponse.ok(null);
    }

    @GetMapping("/questions/{date}")
    public ApiResponse<QuestionResponse> getQuestion(@PathVariable String memberKey,
                                                     @PathVariable String date) {
        // TODO: 2023-09-14 질문 조회
        return ApiResponse.ok(QuestionResponse.builder().build());
    }

    @PostMapping
    public ApiResponse<String> addQuestion(@RequestBody @Valid AddQuestionRequest request,
                                           @PathVariable String memberKey) {
        // TODO: 2023-09-14 질문 등록
        return ApiResponse.ok("");
    }
}
