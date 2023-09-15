package com.keeping.openaiservice.service;

import com.keeping.openaiservice.controller.request.GPTCompletionChatRequest;
import com.keeping.openaiservice.controller.response.CompletionChatResponse;

public interface GptService {

    public CompletionChatResponse completionChat(GPTCompletionChatRequest request);
}
