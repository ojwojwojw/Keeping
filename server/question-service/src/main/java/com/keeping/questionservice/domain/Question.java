package com.keeping.questionservice.domain;

import com.keeping.questionservice.global.common.TimeBaseEntity;
import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@RequiredArgsConstructor
public class Question extends TimeBaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "question_id")
    private Long id;
    
    private String parentKey;
    
    private String childKey;
    
    private String content;
    
    private boolean isCreated;
    
    @Lob
    private String parentAnswer;
    
    @Lob
    private String childAnswer;


    @Builder
    public Question(Long id, String parentKey, String childKey, String content, boolean isCreated, String parentAnswer, String childAnswer) {
        this.id = id;
        this.parentKey = parentKey;
        this.childKey = childKey;
        this.content = content;
        this.isCreated = isCreated;
        this.parentAnswer = parentAnswer;
        this.childAnswer = childAnswer;
    }

    public static Question toQuestion(String parentKey, String childKey, String content, boolean isCreated) {
        return Question.builder()
                .parentKey(parentKey)
                .childKey(childKey)
                .content(content)
                .isCreated(isCreated)
                .build();
    }

    public void updateParentAnswer(String answer) {
        this.parentAnswer = answer;
    }

    public void updateChildAnswer(String answer) {
        this.childAnswer = answer;
    }

}
