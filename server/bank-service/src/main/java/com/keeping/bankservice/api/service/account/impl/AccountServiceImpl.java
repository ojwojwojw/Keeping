package com.keeping.bankservice.api.service.account.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.bankservice.api.controller.account.response.AddAccountResponse;
import com.keeping.bankservice.api.controller.account.response.ShowAccountResponse;
import com.keeping.bankservice.api.service.account.AccountService;
import com.keeping.bankservice.api.service.account.dto.*;
import com.keeping.bankservice.api.service.sms.SmsService;
import com.keeping.bankservice.api.service.sms.dto.MessageDto;
import com.keeping.bankservice.api.service.sms.dto.SmsResponseDto;
import com.keeping.bankservice.domain.account.Account;
import com.keeping.bankservice.domain.account.repository.AccountQueryRepository;
import com.keeping.bankservice.domain.account.repository.AccountRepository;
import com.keeping.bankservice.global.exception.InvalidRequestException;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import com.keeping.bankservice.global.exception.NotFoundException;
import com.keeping.bankservice.global.utils.RedisUtils;
import com.keeping.bankservice.global.utils.ValidationUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Random;

@Service
@Transactional
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

    private final AccountRepository accountRepository;
    private final AccountQueryRepository accountQueryRepository;
//    private final PasswordEncoder passwordEncoder;
    private final RedisUtils redisUtils;
    private final ValidationUtils validationUtils;
    private final SmsService smsService;

    @Override
    public AddAccountResponse addAccount(String memberKey, AddAccountDto dto) throws JsonProcessingException {
        String key = "AccountAuth_" + memberKey;

        if(redisUtils.getRedisValue(key, String.class) == null) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "핸드폰 번호가 인증되지 않았습니다.");
        }

        String accountNumber = createNewAccountNumber();

//        Account account = Account.toAccount(memberKey, accountNumber, passwordEncoder.encode(dto.getAuthPassword()));
        Account account = Account.toAccount(memberKey, accountNumber, dto.getAuthPassword());
        Account saveAccount = accountRepository.save(account);

        return AddAccountResponse.toResponse(saveAccount.getId(), saveAccount.getAccountNumber(), saveAccount.getCreatedDate());
    }

    @Override
    public void checkPhone(String memberKey, CheckPhoneDto dto) throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException, InvalidKeyException, JsonProcessingException {
        String authNumber = validationUtils.createRandomNumCode();

        redisUtils.setRedisValue("AccountPhoneCheck_" + memberKey, authNumber, 210l);

        MessageDto messageDto = MessageDto.builder()
                .to(dto.getPhone())
                .content("[KeePing] 인증번호 [" + authNumber + "]를 입력해 주세요.")
                .build();

        SmsResponseDto response = smsService.sendSmsMessage(messageDto);
    }

    @Override
    public void authPhone(String memberKey, AuthPhoneDto dto) throws JsonProcessingException {
        String key = "AccountPhoneCheck_" + memberKey;
        String value = redisUtils.getRedisValue(key, String.class);

        if(value == null) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "인증번호가 전송되지 않았습니다.");
        }
        else if(!value.equals(dto.getCode())) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "인증번호가 일치하지 않습니다.");
        }

        redisUtils.setRedisValue("AccountAuth_" + memberKey, "true", 210l);
    }

    // TODO: 계좌 잔액이 부족할 때 발생시킬 에러 수정
    @Override
    public Account withdrawMoney(String memberKey, WithdrawMoneyDto dto) {
        Account account = accountRepository.findByAccountNumber(dto.getAccountNumber())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 계좌가 존재하지 않습니다."));

        if(!account.getMemberKey().equals(memberKey)) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "접근 권한이 없습니다.");
        }
        else if(account.getBalance() < dto.getMoney()) {
            throw new InvalidRequestException("400", HttpStatus.BAD_REQUEST, "계좌 잔액이 부족합니다.");
        }

        account.updateBalance(dto.getMoney(), false);

        return account;
    }

    @Override
    public Account depositMoney(String memberKey, DepositMoneyDto dto) {
        Account account = accountRepository.findByAccountNumber(dto.getAccountNumber())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 계좌가 존재하지 않습니다."));

        if(!account.getMemberKey().equals(memberKey)) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "접근 권한이 없습니다.");
        }

        account.updateBalance(dto.getMoney(), true);

        return account;
    }

    @Override
    public ShowAccountResponse showAccount(String memberKey, String targetKey) {
        // TODO: 두 고유 번호가 부모-자녀 관계인지 확인하는 부분 필요

        ShowAccountResponse result = accountQueryRepository.showAccount(targetKey);

        if(result == null) {
            throw new NotFoundException("404", HttpStatus.NOT_FOUND, "해당 회원은 계좌가 없습니다.");
        }

        return result;
    }

    @Override
    public Long showBalance(String memberKey) {
        List<Account> accountList = accountRepository.findByMemberKey(memberKey)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 계좌가 존재하지 않습니다."));

        return accountList.get(0).getBalance();
    }

    private String createNewAccountNumber() throws JsonProcessingException {
        Random rand = new Random();

        int num = 0;
        do {
            num = rand.nextInt(888889) + 111111;
        }
        while(redisUtils.getRedisValue("Account_" + String.valueOf(num), String.class) != null);

        String randomNumber = String.valueOf(num);
        redisUtils.setRedisValue("Account_" + randomNumber, "1");

        String validCode = "";

        int divideNum = num;
        for(int i = 0; i < 3; i++) {
            int num1 = divideNum % 10;
            divideNum /= 10;
            int num2 = divideNum % 10;

            int sum = 0;
            if(i == 1) {
                sum = (num1 * num2) % 10;
            }
            else {
                sum = (num1 + num2) % 10;
            }
            divideNum /= 10;

            validCode = String.valueOf(sum) + validCode;
        }

        return "171-" + randomNumber + "-" + validCode + "-27"; // 3-6-3-2
    }
}
