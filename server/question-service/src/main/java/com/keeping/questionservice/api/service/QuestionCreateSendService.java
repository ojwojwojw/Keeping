package com.keeping.questionservice.api.service;

import com.keeping.questionservice.api.controller.response.QuestionAiResponseList;

public interface QuestionCreateSendService {

    public void addAiQuestion(QuestionAiResponseList responseList);

}
