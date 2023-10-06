package com.completionism.keeping.global.utils;

import org.springframework.stereotype.Component;

import java.util.Random;

@Component
public class ValidationUtils {

    // 문자 인증번호 생성 : 랜덤 숫자 6자리
    public String createRandomNumCode() {
        Random rand = new Random();
        StringBuilder numStr = new StringBuilder();

        for (int i = 0; i < 6; i++) {
            String ran = Integer.toString(rand.nextInt(10));
            numStr.append(ran);
        }

        return numStr.toString();
    }

    // 비밀번호 찾기 난수 생성 : 대문자 + 소문자 + 숫자 13자리
    public String createTempPassword() {
        char[] charSet = new char[] {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' ,
                'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};

        StringBuilder str = new StringBuilder();

        int idx = 0;
        for (int i = 0; i < 13; i++) {
            idx = (int) (charSet.length * Math.random());
            str.append(charSet[idx]);
        }
        return str.toString();
    }
}
