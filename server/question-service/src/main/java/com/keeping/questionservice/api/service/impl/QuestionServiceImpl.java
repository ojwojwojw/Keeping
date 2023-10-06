package com.keeping.questionservice.api.service.impl;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.MemberFeignClient;
import com.keeping.questionservice.api.controller.response.*;
import com.keeping.questionservice.api.service.QuestionService;
import com.keeping.questionservice.api.service.dto.*;
import com.keeping.questionservice.domain.Comment;
import com.keeping.questionservice.domain.Question;
import com.keeping.questionservice.domain.repository.CommentQueryRepository;
import com.keeping.questionservice.domain.repository.CommentRepository;
import com.keeping.questionservice.domain.repository.QuestionQueryRepository;
import com.keeping.questionservice.domain.repository.QuestionRepository;
import com.keeping.questionservice.global.exception.AlreadyExistException;
import com.keeping.questionservice.global.exception.NotFoundException;
import com.keeping.questionservice.global.utils.RedisUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class QuestionServiceImpl implements QuestionService {

    private final MemberFeignClient memberFeignClient;
    private final QuestionRepository questionRepository;
    private final QuestionQueryRepository questionQueryRepository;
    private final CommentRepository commentRepository;
    private final CommentQueryRepository commentQueryRepository;
    private final RedisUtils redisUtils;


    @Override
    @Transactional
    public Long addQuestion(String memberKey, AddQuestionDto dto) {

        // 이미 내일 날짜로 질문이 등록되어 있다면 에러 발생
        LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));
        Optional<QuestionResponse> checkQuestionAdded = questionQueryRepository.findByChildKeyAndSceduledTime(dto.getChildMemberKey(), now);
        if (checkQuestionAdded.isPresent()) {
            throw new AlreadyExistException("409", HttpStatus.CONFLICT, "이미 해당 날짜에 질문이 존재합니다.");
        }
        
        // 질문 등록 시간 넣기
        ApiResponse<MemberTimeResponse> memberTime = memberFeignClient.getMemberTime(memberKey);
        LocalTime registrationTime = memberTime.getResultBody().getRegistrationTime();

        LocalDateTime sendDateTime = now.plusDays(1).atTime(registrationTime);

        Question question = questionRepository.save(Question.toQuestion(memberKey, dto.getChildMemberKey(), dto.getContent(), true, sendDateTime));

        // 만료 시간 = 질문 등록 시간 + 3분
        Long ttl = ((long)registrationTime.getHour() * 60 * 60)
                + ((long)registrationTime.getMinute() * 60) + (3* 60);

        // 레디스에 등록
        String registrationTimeStr = registrationTime.format(DateTimeFormatter.ofPattern("HH:mm"));
        redisUtils.setRedisHash(registrationTimeStr, memberKey, "🫶질문을 확인해보세요", ttl);
        redisUtils.setRedisHash(registrationTimeStr, dto.getChildMemberKey(), "🫶질문을 확인해보세요", ttl);

        return question.getId();
    }

    @Override
    public List<TodayQuestionCommentResponse> showQuestionToday(String memberKey) {

        // 오늘 날짜 구하기
        LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));

        // 오늘 날짜의 질문이 있는지 확인, 없다면 예외 발생
        List<TodayQuestionResponse> todayQuestionResponses = questionQueryRepository.findByChildKeyAndSceduledTimeAtNow(memberKey, now);

        List<TodayQuestionCommentResponse> todayQuestionCommentRespons = new ArrayList<>();
        for (TodayQuestionResponse questionResponse : todayQuestionResponses) {
            // 질문에 댓글 있는지 확인
            List<CommentResponse> commentList = commentQueryRepository.findByIdAndIsActive(questionResponse.getId(), true);
            // 오늘 날짜의 질문에 대한 상세 정보 반환
            TodayQuestionCommentResponse todayQuestionCommentResponse = TodayQuestionCommentResponse.toDto(questionResponse.getId(), questionResponse.getChildMemberKey(), questionResponse.getContent(), questionResponse.isCreated(), questionResponse.getParentAnswer(), questionResponse.getChildAnswer(), commentList);
            todayQuestionCommentRespons.add(todayQuestionCommentResponse);
        }
        return todayQuestionCommentRespons;
    }

    @Override
    public QuestionResponseList showQuestion(String memberKey) {

        List<QuestionResponse> questionByParentKey = questionQueryRepository.getQuestionByMemberKey(memberKey);
        return QuestionResponseList.builder()
                .questions(questionByParentKey)
                .build();
    }

    @Override
    public QuestionResponseList showQuestionByMemberKey(String targetKey) {
        List<QuestionResponse> questionByTargetKey = questionQueryRepository.getQuestionByChildKey(targetKey);
        return QuestionResponseList.builder()
                .questions(questionByTargetKey)
                .build();
    }

    @Override
    public QuestionCommentResponse showDetailQuestion(String memberKey, Long questionId) {
        QuestionResponse questionResponse = questionQueryRepository.getQuetsionByMemberKeyAndId(memberKey, questionId)
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 질문을 찾을 수 없습니다."));

        // 질문의 댓글들 불러오기
        List<CommentResponse> commentList = commentQueryRepository.findByIdAndIsActive(questionId, true);

        return QuestionCommentResponse.builder()
                .question(questionResponse)
                .comments(commentList)
                .build();
    }

    @Override
    @Transactional
    public Long addAnswer(String memberKey, AddAnswerDto dto) {

        // 질문에 대한 답변 등록
        // 질문 id로 질문 찾아오고 답변 수정
        Question question = questionRepository.findById(dto.getQuestionId())
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 질문을 찾을 수 없습니다."));

        log.debug("[질문] : " + question.toString());

        // 부모일 때 부모 답변으로 넣기
        if (dto.isParent()) {
            question.updateParentAnswer(dto.getAnswer());
        } else {
            question.updateChildAnswer(dto.getAnswer());
        }

        return question.getId();
    }

    @Override
    @Transactional
    public Long addComment(String memberKey, AddCommentDto dto) {

        // questionId로 해당 질문 가져오기
        Question question = questionRepository.findById(dto.getQuestionId())
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 질문이 없습니다."));

        // Comment entity 생성 후 저장
        Comment comment = Comment.toComment(question, memberKey, dto.getContent(), true);

        Comment save = commentRepository.save(comment);
        return save.getId();
    }

    @Override
    @Transactional
    public void editQuestion(String memberKey, EditQuestionDto dto) {

        // questionId로 해당 질문 가져오기
        Question question = questionRepository.findById(dto.getQuestionId())
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 질문이 없습니다."));

        question.updateQuestion(dto.getContent());
    }

    @Override
    @Transactional
    public void editComment(String memberKey, EditCommentDto dto) {

        // commentId로 해당 댓글 가져오기
        Comment comment = commentRepository.findByIdAndIsActive(dto.getCommentId(), true)
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 댓글이 없습니다."));

        comment.updateComment(dto.getContent());

    }

    @Override
    @Transactional
    public void removeComment(String memberKey, Long commentId) {

        // commentId로 해당 댓글 가져오기
        Comment comment = commentRepository.findByIdAndIsActive(commentId, true)
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 댓글이 없습니다."));

        comment.deleteComment();
    }
}
