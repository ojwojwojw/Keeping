package com.keeping.openaiservice.api.controller.response.api.service.impl;

import com.keeping.openaiservice.api.controller.response.api.controller.request.GPTCompletionChatRequest;
import com.keeping.openaiservice.api.controller.response.api.controller.request.TransactionDetailRequest;
import com.keeping.openaiservice.api.controller.response.api.controller.request.TransactionRequest;
import com.keeping.openaiservice.api.controller.response.api.controller.request.TransactionRequestList;
import com.keeping.openaiservice.api.controller.response.api.controller.response.CompletionChatResponse;
import com.keeping.openaiservice.api.controller.response.api.controller.response.QuestionAiResponse;
import com.keeping.openaiservice.api.controller.response.api.service.GptService;
import com.keeping.openaiservice.domain.TransactionType;
import com.theokanning.openai.completion.chat.ChatCompletionResult;
import com.theokanning.openai.service.OpenAiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class GptServiceImpl implements GptService {
    
    private final OpenAiService openAiService;

    @Override
    public QuestionAiResponse createQuestion(TransactionRequestList request) {
        
        List<TransactionRequest> requestList = request.getTransactionRequsetList();

        StringBuilder sendText = new StringBuilder();

        String transactionStr = "";
        for (TransactionRequest transactionRequest : requestList) {

            transactionStr = "오늘 날짜와 시간은 " + transactionRequest.getCreatedDate() + " 이거야\n";
            
            transactionStr += "가게 이름은 " + transactionRequest.getStoreName() + " 여기야.\n";

            sendText.append(transactionStr);
            
            transactionStr = "여기서 " + transactionRequest.getCategory() + "라는 품목으로 ";
            
            if (transactionRequest.getType().equals(TransactionType.DEPOSIT)) {
                transactionStr += transactionRequest.getMoney() + "원의 돈을 받았어.\n";
            } else if (transactionRequest.getType().equals(TransactionType.WITHDRAW)) {
                transactionStr += "여기서 " + transactionRequest.getMoney() + "원의 돈을 썼어.\n";
            }

            sendText.append(transactionStr);

            transactionStr = "잔금은 " + transactionRequest.getBalance() + "원이야.\n";

            transactionStr += "주소는 " + transactionRequest.getAddress() + "이야.\n";

            sendText.append(transactionStr);
            
            // 상세 거래내역이 있을 경우
            if (transactionRequest.isDetailed()) {
                List<TransactionDetailRequest> detailRequests = transactionRequest.getTransactionDetailRequestList();

                transactionStr = "여기서부터 이 가게에서 쓴 목록이야.\n";
                sendText.append(transactionStr);
                for (TransactionDetailRequest detailRequest : detailRequests) {

                    transactionStr = "물건은 " + detailRequest.getContent() + " 이야.\n";

                    transactionStr += "가격은 " + detailRequest.getMoney() + "원이야\n";

                    transactionStr += "품목은 " + detailRequest.getCategory() + "이야\n";

                    transactionStr += "여기까지 한 물건에 대한 정보야\n";

                    sendText.append(transactionStr);
                }
            }
        }

        transactionStr = "여기까지가 거래내역에 대한 정보야. 이 내용을 바탕으로 초등학생 고학년 대상으로 경제 관념을 키워줄 만한 금융 관련한 질문을 해줘. 말투는 선생님 말투로 부드럽게 해줘.";
        sendText.append(transactionStr);

        CompletionChatResponse chatResponse = completionChat(GPTCompletionChatRequest.builder()
                .role("user")
                .message(sendText.toString())
                .build());
        return QuestionAiResponse.builder()
                .answer(chatResponse.getMessages().get(0).toString())
                .build();
    }

    @Override
    public CompletionChatResponse completionChat(GPTCompletionChatRequest request) {
        ChatCompletionResult chatCompletion = openAiService.createChatCompletion(
                GPTCompletionChatRequest.of(request));

        CompletionChatResponse response = CompletionChatResponse.of(chatCompletion);

        List<String> messages = response.getMessages().stream()
                .map(CompletionChatResponse.Message::getMessage)
                .collect(Collectors.toList());
        
        log.info("messages={}", messages);
        return response;
    }
    
}
