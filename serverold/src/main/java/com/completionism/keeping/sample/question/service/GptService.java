package com.completionism.keeping.sample.question.service;

import com.completionism.keeping.sample.question.controller.request.GPTCompletionChatRequest;
import com.completionism.keeping.sample.question.controller.response.CompletionChatResponse;

public interface GptService {

    public CompletionChatResponse completionChat(GPTCompletionChatRequest request);
}
