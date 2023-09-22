package com.keeping.questionservice.api.service.impl;

import com.keeping.questionservice.api.controller.response.MemberTypeResponse;
import com.keeping.questionservice.api.controller.response.QuestionResponse;
import com.keeping.questionservice.api.controller.response.QuestionResponseList;
import com.keeping.questionservice.api.service.QuestionService;
import com.keeping.questionservice.api.service.dto.AddAnswerDto;
import com.keeping.questionservice.api.service.dto.AddQuestionDto;
import com.keeping.questionservice.domain.Question;
import com.keeping.questionservice.domain.repository.QuestionQueryRepository;
import com.keeping.questionservice.domain.repository.QuestionRepository;
import com.keeping.questionservice.global.exception.AlreadyExistException;
import com.keeping.questionservice.global.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class QuestionServiceImpl implements QuestionService {

    private final QuestionRepository questionRepository;
    private final QuestionQueryRepository questionQueryRepository;

    @Override
    public Long addQuestion(String memberKey, AddQuestionDto dto) {

        // 이미 오늘 날짜로 질문이 등록되어 있다면 에러 발생
        LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));
        questionQueryRepository.findByChildKeyAndCreatedDate(dto.getChildMemberKey(), now)
                .orElseThrow(() -> new AlreadyExistException("409", HttpStatus.CONFLICT, "이미 해당 날짜에 질문이 존재합니다."));

        Question question = questionRepository.save(Question.toQuestion(memberKey, dto.getChildMemberKey(), dto.getContent(), true));

        return question.getId();
    }

    @Override
    public QuestionResponseList showQuestion(String memberKey) {

        List<QuestionResponse> questionByParentKey = questionQueryRepository.getQuestionByMemberKey(memberKey);
        return QuestionResponseList.builder()
                .questionResponseList(questionByParentKey)
                .build();
    }

    @Override
    public QuestionResponse showDetailQuestion(String memberKey, Long questionId) {
        return questionQueryRepository.getQuetsionByMemberKeyAndId(memberKey, questionId)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 질문을 찾을 수 없습니다."));
    }

    @Override
    public Long addAnswer(String memberKey, AddAnswerDto dto) {

        // TODO: 2023-09-22 부모라면 자녀 키를 가져오고, 자녀라면 부모 키를 가져와야 함
        
//        questionRepository.save(Question.toQuestion())
        
        return null;
    }
}
