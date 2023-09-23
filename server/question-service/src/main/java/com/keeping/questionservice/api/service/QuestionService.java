package com.keeping.questionservice.api.service;

import com.keeping.questionservice.api.controller.response.QuestionResponse;
import com.keeping.questionservice.api.controller.response.QuestionResponseList;
import com.keeping.questionservice.api.controller.response.TodayQuestionResponse;
import com.keeping.questionservice.api.service.dto.AddAnswerDto;
import com.keeping.questionservice.api.service.dto.AddQuestionDto;

public interface QuestionService {

    public Long addQuestion(String memberKey, AddQuestionDto dto);

    public TodayQuestionResponse showQuestionToday(String memberKey);

    public QuestionResponseList showQuestion(String memberKey);

    public QuestionResponse showDetailQuestion(String memberKey, Long questionId);

    public Long addAnswer(String memberKey, AddAnswerDto dto);
    
}
