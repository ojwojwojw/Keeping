package com.keeping.questionservice.api.controller;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.response.QuestionAiResponseList;
import com.keeping.questionservice.api.service.QuestionCreateSendService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping("/question-service/api")
public class QuestionAiController {

    private final QuestionCreateSendService questionCreateSendService;

    @PostMapping("/save-api-question")
    ApiResponse<Void> addAiQuestion(@RequestBody QuestionAiResponseList responseList) {
        questionCreateSendService.addAiQuestion(responseList);
        return ApiResponse.ok(null);
    }
}
