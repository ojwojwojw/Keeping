package com.keeping.questionservice.api.service;

import com.keeping.questionservice.api.controller.response.QuestionCommentResponse;
import com.keeping.questionservice.api.controller.response.QuestionResponseList;
import com.keeping.questionservice.api.controller.response.TodayQuestionCommentResponse;
import com.keeping.questionservice.api.service.dto.*;

import java.util.List;

public interface QuestionService {

    public Long addQuestion(String memberKey, AddQuestionDto dto);

    public List<TodayQuestionCommentResponse> showQuestionToday(String memberKey);

    public QuestionResponseList showQuestion(String memberKey);

    public QuestionCommentResponse showDetailQuestion(String memberKey, Long questionId);

    public Long addAnswer(String memberKey, AddAnswerDto dto);

    public Long addComment(String memberKey, AddCommentDto dto);

    public void editQuestion(String memberKey, EditQuestionDto dto);

    public void editComment(String memberKey, EditCommentDto dto);

    public void removeComment(String memberKey, Long commentId);
    
}
