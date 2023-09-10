package com.completionism.keeping.sample.sms;

import com.completionism.keeping.api.service.sms.dto.MessageDto;
import com.completionism.keeping.api.service.sms.dto.SmsResponseDto;
import com.completionism.keeping.api.service.sms.impl.SmsServiceImpl;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

@SpringBootTest
@Transactional
public class SmsSampleTeset {

    @Autowired
    SmsServiceImpl smsServiceImpl;

    @Test
    @DisplayName("sms 전송 샘플 코드")
    void smsSampleTest() throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException, InvalidKeyException, JsonProcessingException {
        // given
        String phoneNumber = ""; // 여기에 본인 핸드폰 번호 입력
        MessageDto dto = MessageDto.builder()
                .to(phoneNumber)
                .content("sms 전송 테스트입니다.")
                .build();

        // when
        SmsResponseDto response = smsServiceImpl.sendSmsMessage(dto);
    }
}
