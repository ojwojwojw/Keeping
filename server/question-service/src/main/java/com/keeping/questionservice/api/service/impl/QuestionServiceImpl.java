package com.keeping.questionservice.api.service.impl;

import com.keeping.questionservice.api.ApiResponse;
import com.keeping.questionservice.api.controller.MemberFeignClient;
import com.keeping.questionservice.api.controller.OpenaiFeignClient;
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
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class QuestionServiceImpl implements QuestionService {

    private MemberFeignClient memberFeignClient;
    private OpenaiFeignClient openaiFeignClient;
    private final QuestionRepository questionRepository;
    private final QuestionQueryRepository questionQueryRepository;
    private final CommentRepository commentRepository;
    private final CommentQueryRepository commentQueryRepository;


    @Override
    public Long addQuestion(String memberKey, AddQuestionDto dto) {

        // 이미 오늘 날짜로 질문이 등록되어 있다면 에러 발생
        LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));
        Optional<QuestionResponse> checkQuestionAdded = questionQueryRepository.findByChildKeyAndCreatedDate(dto.getChildMemberKey(), now);
        if (checkQuestionAdded.isPresent()) {
            throw new AlreadyExistException("409", HttpStatus.CONFLICT, "이미 해당 날짜에 질문이 존재합니다.");
        }
        
        // 질문 등록 시간 넣기
        ApiResponse<MemberTimeResponse> memberTime = memberFeignClient.getMemberTime(memberKey);
        LocalTime registrationTime = memberTime.getResultBody().getRegistrationTime();

        Question question = questionRepository.save(Question.toQuestion(memberKey, dto.getChildMemberKey(), dto.getContent(), true, registrationTime));

        return question.getId();
    }

    @Override
    public TodayQuestionResponse showQuestionToday(String memberKey) {

        // 오늘 날짜 구하기
        LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));

        // 오늘 날짜의 질문이 있는지 확인, 없다면 예외 발생
        QuestionResponse questionResponse = questionQueryRepository.findByChildKeyAndCreatedDate(memberKey, now)
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "오늘 질문이 없습니다."));

        // 질문에 댓글 있는지 확인
        List<CommentResponse> commentList = commentQueryRepository.findByIdAndActive(memberKey, true);

        // 오늘 날짜의 질문에 대한 상세 정보 반환
        return TodayQuestionResponse.toDto(questionResponse.getId(), questionResponse.getContent(), questionResponse.isCreated(), questionResponse.getParentAnswer(), questionResponse.getChildAnswer(), commentList);
    }

    @Override
    public QuestionResponseList showQuestion(String memberKey) {

        List<QuestionResponse> questionByParentKey = questionQueryRepository.getQuestionByMemberKey(memberKey);
        return QuestionResponseList.builder()
                .questions(questionByParentKey)
                .build();
    }

    @Override
    public QuestionResponse showDetailQuestion(String memberKey, Long questionId) {
        QuestionResponse questionResponse = questionQueryRepository.getQuetsionByMemberKeyAndId(memberKey, questionId)
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 질문을 찾을 수 없습니다."));

        // 질문의 댓글들 불러오기
        List<CommentResponse> commentList = commentQueryRepository.findByIdAndActive(memberKey, true);

        questionResponse.setComments(commentList);

        return questionResponse;
    }

    @Override
    public Long addAnswer(String memberKey, AddAnswerDto dto) {

        // member type 가져오기
        ApiResponse<MemberTypeResponse> memberType = memberFeignClient.getMemberType(memberKey);

        // 질문에 대한 답변 등록
        // 질문 id로 질문 찾아오고 답변 수정
        Question question = questionRepository.findById(dto.getQuestionId())
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 질문을 찾을 수 없습니다."));

        // 부모일 때 부모 답변으로 넣기
        if (memberType.getResultBody().isParent()) {
            question.updateParentAnswer(dto.getAnswer());
        } else {
            question.updateChildAnswer(dto.getAnswer());
        }

        return question.getId();
    }

    @Override
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
    public void editQuestion(String memberKey, EditQuestionDto dto) {

        // questionId로 해당 질문 가져오기
        Question question = questionRepository.findById(dto.getQuestionId())
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 질문이 없습니다."));

        question.updateQuestion(dto.getContent());
    }

    @Override
    public void editComment(String memberKey, EditCommentDto dto) {

        // commentId로 해당 댓글 가져오기
        Comment comment = commentRepository.findByIdAndActive(dto.getCommentId(), true)
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 댓글이 없습니다."));

        comment.updateComment(dto.getContent());

    }

    @Override
    public void removeComment(String memberKey, Long commentId) {

        // commentId로 해당 댓글 가져오기
        Comment comment = commentRepository.findByIdAndActive(commentId, true)
                .orElseThrow(() -> new NotFoundException("400", HttpStatus.BAD_REQUEST, "해당하는 댓글이 없습니다."));

        comment.deleteComment();
    }

    @Scheduled(cron = "0 0 0 * * ?")
    private void createQuestion() {
        // 질문 생성하기
        ApiResponse<QuestionAiResponseList> questionAiResponseList = openaiFeignClient.createQuestion();
        List<QuestionAiResponse> questionAiResponses = questionAiResponseList.getResultBody().getQuestionAiResponses();
        
        List<Question> questions = new ArrayList<>();

        for (QuestionAiResponse questionAiResponse : questionAiResponses) {
            String parentMemberKey = questionAiResponse.getParentMemberKey();
            String childMemberKey = questionAiResponse.getChildMemberKey();
            
            // 이미 오늘 날짜로 질문이 등록되어 있다면 에러 발생
            LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));
            Optional<QuestionResponse> checkQuestionAdded = questionQueryRepository.findByChildKeyAndCreatedDate(childMemberKey, now);
            if (checkQuestionAdded.isPresent()) {
                throw new AlreadyExistException("409", HttpStatus.CONFLICT, "이미 해당 날짜에 질문이 존재합니다.");
            }
    
            // 질문 등록 시간 넣기
            ApiResponse<MemberTimeResponse> memberTime = memberFeignClient.getMemberTime(parentMemberKey);
            LocalTime registrationTime = memberTime.getResultBody().getRegistrationTime();

            questions.add(Question.toQuestion(parentMemberKey, childMemberKey, questionAiResponse.getAnswer(), false, registrationTime));
        }
        questionRepository.saveAll(questions);
    }
}
