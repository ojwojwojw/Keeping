package com.keeping.questionservice.api.service.impl;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.MemberFeignClient;
import com.keeping.questionservice.api.controller.NotiFeignClient;
import com.keeping.questionservice.api.controller.OpenaiFeignClient;
import com.keeping.questionservice.api.controller.request.QuestionNotiRequest;
import com.keeping.questionservice.api.controller.request.QuestionNotiRequestList;
import com.keeping.questionservice.api.controller.response.MemberTimeResponse;
import com.keeping.questionservice.api.controller.response.QuestionAiResponse;
import com.keeping.questionservice.api.controller.response.QuestionAiResponseList;
import com.keeping.questionservice.api.controller.response.QuestionResponse;
import com.keeping.questionservice.api.service.QuestionCreateSendService;
import com.keeping.questionservice.domain.Question;
import com.keeping.questionservice.domain.repository.QuestionQueryRepository;
import com.keeping.questionservice.domain.repository.QuestionRepository;
import com.keeping.questionservice.global.utils.RedisUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class QuestionCreateSendServiceImpl implements QuestionCreateSendService {

    private final MemberFeignClient memberFeignClient;
    private final OpenaiFeignClient openaiFeignClient;
    private final NotiFeignClient notiFeignClient;
    private final QuestionRepository questionRepository;
    private final QuestionQueryRepository questionQueryRepository;
    private final RedisTemplate<String, String> redisTemplate;
    private final RedisUtils redisUtils;
    
    
//    @Scheduled(cron = "0 0 0 * * ?")
    private void createQuestion() {
        // 질문 생성하기
        ApiResponse<QuestionAiResponseList> questionAiResponseList = openaiFeignClient.createQuestion();
        List<QuestionAiResponse> questionAiResponses = questionAiResponseList.getResultBody().getQuestionAiResponses();

        List<Question> questions = new ArrayList<>();
        
        // redis에 저장
        HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();

        for (QuestionAiResponse questionAiResponse : questionAiResponses) {
            String parentMemberKey = questionAiResponse.getParentMemberKey();
            String childMemberKey = questionAiResponse.getChildMemberKey();

            // 이미 오늘 날짜로 질문이 등록되어 있다면 패쓰
            LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));
            Optional<QuestionResponse> checkQuestionAdded = questionQueryRepository.findByChildKeyAndSceduledTimeAtNow(childMemberKey, now);
            if (checkQuestionAdded.isEmpty()) {
                // 질문 등록 시간 넣기
                ApiResponse<MemberTimeResponse> memberTime = memberFeignClient.getMemberTime(parentMemberKey);
                LocalTime registrationTime = memberTime.getResultBody().getRegistrationTime();

                LocalDateTime sendDateTime = now.atTime(registrationTime);
                questions.add(Question.toQuestion(parentMemberKey, childMemberKey, questionAiResponse.getAnswer(), false, sendDateTime));
                String registrationTimeStr = registrationTime.format(DateTimeFormatter.ofPattern("HH:mm"));
                
                // 만료 시간 = 질문 등록 시간 + 3분
                Long ttl = ((long)registrationTime.getHour() * 60 * 60)
                        + ((long)registrationTime.getMinute() * 60) + (3* 60);
                
                redisUtils.setRedisHash(registrationTimeStr, parentMemberKey, questionAiResponse.getAnswer(), ttl);
                redisUtils.setRedisHash(registrationTimeStr, childMemberKey, questionAiResponse.getAnswer(), ttl);
            }
        }
        questionRepository.saveAll(questions);
    }

//    @Scheduled(cron = "0 0 1/0 * * ?")
//    private void sendQuestionByCustom() {
//
//        // 현재 시간
//        LocalTime now = LocalTime.now(ZoneId.of("Asia/Seoul"));
//        String nowStr = now.format(DateTimeFormatter.ofPattern("HH:mm"));
//
//        Map<String, String> memberKeyQuestion = redisUtils.getRedisHash(nowStr);
//
//        List<QuestionNotiRequest> notiRequests = new ArrayList<>();
//
//        for (String memberKey : memberKeyQuestion.keySet()) {
//            // noti로 알람 보내기
//            notiRequests.add(QuestionNotiRequest.builder()
//                    .memberKey(memberKey)
//                    .title("질문이 도착했어요!!")
//                    .body(memberKeyQuestion.get(memberKey))
//                    .build());
//        }
//
//        notiFeignClient.sendQuestionNoti(QuestionNotiRequestList.builder()
//                .questionNotiRequests(notiRequests)
//                .build());
//
//    }

    @Scheduled(cron = "0 0 20 * * ?")
    private void sendQuestion() {
        // 현재 시간
        LocalTime now = LocalTime.now(ZoneId.of("Asia/Seoul"));
        String nowStr = now.format(DateTimeFormatter.ofPattern("HH:mm"));

        Map<String, String> memberKeyQuestion = redisUtils.getRedisHash(nowStr);

        List<QuestionNotiRequest> notiRequests = new ArrayList<>();

        for (String memberKey : memberKeyQuestion.keySet()) {
            // noti로 알람 보내기
            notiRequests.add(QuestionNotiRequest.builder()
                    .memberKey(memberKey)
                    .title("질문이 도착했어요!!")
                    .body(memberKeyQuestion.get(memberKey))
                    .build());
        }

        notiFeignClient.sendQuestionNoti(QuestionNotiRequestList.builder()
                .questionNotiRequests(notiRequests)
                .build());

    }

    @Scheduled(cron = "0 */2 * * * ?")
    private void sendQuestionTest() {
        // 현재 시간
        String testTime = "20:00";

        log.debug("[test time] : " +  testTime);
        Map<String, String> memberKeyQuestion = redisUtils.getRedisHash(testTime);

        log.debug("[레디스 테스트] : " + memberKeyQuestion.toString());

        List<QuestionNotiRequest> notiRequests = new ArrayList<>();

        for (String memberKey : memberKeyQuestion.keySet()) {
            // noti로 알람 보내기
            notiRequests.add(QuestionNotiRequest.builder()
                    .memberKey(memberKey)
                    .title("질문이 도착했어요!!")
                    .body(memberKeyQuestion.get(memberKey))
                    .build());
        }

        log.debug("[알람 보내기] : " + notiRequests.toString());
        notiFeignClient.sendQuestionNoti(QuestionNotiRequestList.builder()
                .questionNotiRequests(notiRequests)
                .build());

        log.debug("[알람 보내기 성공]");
    }
}
