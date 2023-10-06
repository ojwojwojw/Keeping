package com.keeping.openaiservice.api.service;

import com.keeping.openaiservice.api.controller.request.GPTCompletionChatRequest;
import com.keeping.openaiservice.api.controller.response.CompletionChatResponse;
import com.keeping.openaiservice.api.controller.response.QuestionAiResponseList;

public interface GptService {

    public CompletionChatResponse completionChat(GPTCompletionChatRequest request);
    
}
