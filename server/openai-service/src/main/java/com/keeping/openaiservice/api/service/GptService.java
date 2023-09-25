package com.keeping.openaiservice.api.service;

import com.keeping.openaiservice.api.controller.request.GPTCompletionChatRequest;
import com.keeping.openaiservice.api.controller.request.TransactionDetailRequest;
import com.keeping.openaiservice.api.controller.request.TransactionRequestList;
import com.keeping.openaiservice.api.controller.response.CompletionChatResponse;
import com.keeping.openaiservice.api.controller.response.QuestionAiResponse;

public interface GptService {

    public QuestionAiResponse createQuestion(TransactionRequestList request); 

    public CompletionChatResponse completionChat(GPTCompletionChatRequest request);
    
}
