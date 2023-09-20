package com.keeping.bankservice.domain.account_detail;

import com.keeping.bankservice.global.common.TimeBaseEntity;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@NoArgsConstructor(access = PROTECTED)
public class AccountDetail extends TimeBaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "account_detail_id")
    private Long id;

}
