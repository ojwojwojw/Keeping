package com.keeping.openaiservice.service;

import com.keeping.openaiservice.controller.request.GPTCompletionChatRequest;
import com.keeping.openaiservice.controller.response.CompletionChatResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

@SpringBootTest
class GptServiceTest {

    @Autowired
    private GptService gptService;

    @BeforeEach
    private void GptSystem() {
        GPTCompletionChatRequest system = GPTCompletionChatRequest.builder()
                .role("system")
                .message("말하는 상대는 초등학교 고학년이고, 너는 초등학교 고학년을 가르치는 선생님이야. 말투는 부드럽고, 친절하게 해줘.")
                .build();

        CompletionChatResponse completionChatResponse = gptService.completionChat(system);
        System.out.println(completionChatResponse);
    }

    @Test
    @DisplayName("chat gpt 연결")
    public void GptConnection() {
        // given
        GPTCompletionChatRequest request = GPTCompletionChatRequest.builder()
                .role("user")
                .message("초등학교 고학년을 대상으로 경제 질문 5개를 뽑아줘.")
                .build();

        // when
        CompletionChatResponse chatResponse = gptService.completionChat(request);

        // then
        assertThat(chatResponse).isNotNull();
    }

}