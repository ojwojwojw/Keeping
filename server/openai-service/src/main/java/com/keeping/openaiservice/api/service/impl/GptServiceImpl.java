package com.keeping.openaiservice.api.service.impl;

import com.keeping.openaiservice.api.ApiResponse;
import com.keeping.openaiservice.api.controller.BankFeignClient;
import com.keeping.openaiservice.api.controller.QuestionFeignClient;
import com.keeping.openaiservice.api.controller.request.*;
import com.keeping.openaiservice.api.controller.response.*;
import com.keeping.openaiservice.api.service.GptService;
import com.theokanning.openai.completion.chat.ChatCompletionResult;
import com.theokanning.openai.service.OpenAiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class GptServiceImpl implements GptService {
    
    private final OpenAiService openAiService;
    private final BankFeignClient bankFeignClient;
    private final QuestionFeignClient questionFeignClient;

    @Scheduled(cron = "0 15 18 * * ?", zone = "Asia/Seoul")
    private void createQuestion() {
        log.debug("[질문 생성하기]");
        ApiResponse<List<TransactionResponseList>> transactionData = bankFeignClient.getTransactionData();

        List<TransactionResponseList> transactionResponseLists = transactionData.getResultBody();

        List<QuestionAiResponse> questionAiResponses = new ArrayList<>();

        log.debug("[거래내역 정보] :  " + transactionResponseLists.toString());

        for (TransactionResponseList transactionResponseList : transactionResponseLists) {

            List<TransactionResponse> requestList = transactionResponseList.getTransactionList();

            StringBuilder sendText = new StringBuilder();

            String transactionStr = "";

            if (!requestList.isEmpty()) {
                for (TransactionResponse transactionResponse : requestList) {

                    transactionStr = "오늘 날짜와 시간은 " + transactionResponse.getCreatedDate() + " 이거야\n";

                    transactionStr += "가게 이름은 " + transactionResponse.getStoreName() + " 여기야.\n";

                    sendText.append(transactionStr);

                    transactionStr = "여기서 " + transactionResponse.getLargeCategory().getText() + "라는 품목으로 ";

                    if (transactionResponse.isType()) {
                        transactionStr += transactionResponse.getMoney() + "원의 돈을 받았어.\n";
                    } else {
                        transactionStr += "여기서 " + transactionResponse.getMoney() + "원의 돈을 썼어.\n";
                    }

                    sendText.append(transactionStr);

                    transactionStr = "잔금은 " + transactionResponse.getBalance() + "원이야.\n";

                    transactionStr += "주소는 " + transactionResponse.getAddress() + "이야.\n";

                    sendText.append(transactionStr);

                    // 상세 거래내역이 있을 경우
                    if (transactionResponse.isDetailed()) {
                        List<TransactionDetailRequest> detailRequests = transactionResponse.getDetailList();

                        transactionStr = "여기서부터 이 가게에서 쓴 목록이야.\n";
                        sendText.append(transactionStr);
                        for (TransactionDetailRequest detailRequest : detailRequests) {

                            transactionStr = "물건은 " + detailRequest.getContent() + " 이야.\n";

                            transactionStr += "가격은 " + detailRequest.getMoney() + "원이야\n";

                            transactionStr += "품목은 " + detailRequest.getSmallCategory().getText() + "이야\n";

                            transactionStr += "여기까지 한 물건에 대한 정보야\n";

                            sendText.append(transactionStr);
                        }
                    }
                }
                transactionStr = "여기까지가 거래내역에 대한 정보야. 이 내용을 바탕으로 초등학생 고학년 대상으로 경제 관념을 키워줄 만한 금융 관련한 질문 한 개를 만들어줘.";
                sendText.append(transactionStr);
            }
            else {
                transactionStr = "초등학생 고학년 대상으로 경제 관념을 키워줄 만한 금융 관련한 질문 한 개를 만들어줘.";
                sendText.append(transactionStr);
            }

            log.debug("[거래내역 멤버키] : " + transactionResponseList.getChildMemberKey());
            log.debug("[보낼 값] : " + transactionStr);

            CompletionChatResponse chatResponse = completionChat(GPTCompletionChatRequest.builder()
                    .role("user")
                    .message(sendText.toString())
                    .build());

            questionAiResponses.add(QuestionAiResponse.builder()
                    .parentMemberKey(transactionResponseList.getParentMemberKey())
                    .childMemberKey(transactionResponseList.getChildMemberKey())
                    .answer(chatResponse.getMessages().stream()
                            .map(CompletionChatResponse.Message::getMessage)
                            .collect(Collectors.toList())
                            .get(0))
                    .build());

        }
        QuestionAiResponseList requestList = QuestionAiResponseList.builder()
                .questionAiResponses(questionAiResponses)
                .build();

        // 질문 리스트 전달
        questionFeignClient.addAiQuestion(requestList);
    }

    @Override
    public CompletionChatResponse completionChat(GPTCompletionChatRequest request) {
        ChatCompletionResult chatCompletion = openAiService.createChatCompletion(
                GPTCompletionChatRequest.of(request));

        CompletionChatResponse response = CompletionChatResponse.of(chatCompletion);

        List<String> messages = response.getMessages().stream()
                .map(CompletionChatResponse.Message::getMessage)
                .collect(Collectors.toList());
        
        log.debug("[AI 메시지]={}", messages);
        return response;
    }
    
}
