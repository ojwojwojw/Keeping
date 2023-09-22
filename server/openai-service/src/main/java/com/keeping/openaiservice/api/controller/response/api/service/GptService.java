package com.keeping.openaiservice.api.controller.response.api.service;

import com.keeping.openaiservice.api.controller.response.api.controller.request.GPTCompletionChatRequest;
import com.keeping.openaiservice.api.controller.response.api.controller.request.TransactionRequestList;
import com.keeping.openaiservice.api.controller.response.api.controller.response.CompletionChatResponse;
import com.keeping.openaiservice.api.controller.response.api.controller.response.QuestionAiResponse;

public interface GptService {

    public QuestionAiResponse createQuestion(TransactionRequestList request); 

    public CompletionChatResponse completionChat(GPTCompletionChatRequest request);
    
}
