package com.keeping.questionservice.domain;

import com.keeping.questionservice.global.common.TimeBaseEntity;
import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
@RequiredArgsConstructor
public class Comment extends TimeBaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "comment_id")
    private Long id;

    @JoinColumn(name = "question_id", nullable = false)
    @ManyToOne
    private Question question;

    @Column(nullable = false)
    private String memberKey;

    @Lob
    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private boolean isActive;

    @Builder
    public Comment(Long id, Question question, String memberKey, String content, boolean isActive) {
        this.id = id;
        this.question = question;
        this.memberKey = memberKey;
        this.content = content;
        this.isActive = isActive;
    }

    public static Comment toComment(Question question, String memberKey, String content, boolean isActive) {
        return Comment.builder()
                .question(question)
                .memberKey(memberKey)
                .content(content)
                .isActive(isActive)
                .build();
    }

    public void updateComment(String content) {
        this.content = content;
    }

    public void deleteComment() {
        this.isActive = false;
    }


}
