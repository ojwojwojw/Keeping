//package com.keeping.bankservice.api.service.account.impl;
//
//import com.completionism.keeping.api.service.account.AccountService;
//import com.completionism.keeping.api.service.account.dto.AddAccountDto;
//import com.completionism.keeping.domain.account.Account;
//import com.completionism.keeping.domain.account.repository.AccountRepository;
//import com.completionism.keeping.domain.member.Member;
//import com.completionism.keeping.global.utils.RedisUtils;
//import com.fasterxml.jackson.core.JsonProcessingException;
//import lombok.RequiredArgsConstructor;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//
//import java.util.Random;
//
//@Service
//@Transactional
//@RequiredArgsConstructor
//public class AccountServiceImpl implements AccountService {
//
////    private final MemberRepository memberRepository;
//    private final AccountRepository accountRepository;
//    private final RedisUtils redisUtils;
//    private final PasswordEncoder passwordEncoder;
//
//    @Override
//    public Long addAccount(String loginId, AddAccountDto dto) throws JsonProcessingException {
//        Member member = null;
////        Member member = memberRepository.findByLoginId(loginId).orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당 회원이 존재하지 않습니다."));
//
//        String accountNumber = createNewAccountNumber();
//
//        Account account = Account.toAccount(member, accountNumber, passwordEncoder.encode(dto.getAuthPassword()), 0l, true);
//        Account saveAccount = accountRepository.save(account);
//
//        return saveAccount.getId();
//    }
//
//    private String createNewAccountNumber() throws JsonProcessingException {
//        Random rand = new Random();
//
//        int num = 0;
//        do {
//            num = rand.nextInt(888889) + 111111;
//        }
//        while(redisUtils.getRedisValue("Account_" + String.valueOf(num), String.class) != null);
//
//        String randomNumber = String.valueOf(num);
//        redisUtils.setRedisValue("Account_" + randomNumber, "true");
//
//        String validCode = "";
//
//        int divideNum = num;
//        for(int i = 0; i < 3; i++) {
//            int num1 = divideNum % 10;
//            divideNum /= 10;
//            int num2 = divideNum % 10;
//
//            int sum = 0;
//            if(i == 1) {
//                sum = (num1 * num2) % 10;
//            }
//            else {
//                sum = (num1 + num2) % 10;
//            }
//            divideNum /= 10;
//
//            validCode = String.valueOf(sum) + validCode;
//        }
//
//        return "171-" + randomNumber + "-" + validCode + "-27"; // 3-6-3-2
//    }
//}
