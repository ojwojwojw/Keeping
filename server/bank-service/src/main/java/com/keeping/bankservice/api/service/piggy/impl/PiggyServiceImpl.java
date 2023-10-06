package com.keeping.bankservice.api.service.piggy.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.bankservice.api.controller.feign_client.MemberFeignClient;
import com.keeping.bankservice.api.controller.feign_client.NotiFeignClient;
import com.keeping.bankservice.api.controller.feign_client.request.SendNotiRequest;
import com.keeping.bankservice.api.controller.piggy.response.SavingPiggyResponse;
import com.keeping.bankservice.api.controller.piggy.response.ShowPiggyResponse;
import com.keeping.bankservice.api.service.account.AccountService;
import com.keeping.bankservice.api.service.account.dto.SavingPiggyDto;
import com.keeping.bankservice.api.service.account.dto.WithdrawMoneyDto;
import com.keeping.bankservice.api.service.account_history.AccountHistoryService;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import com.keeping.bankservice.api.service.piggy.PiggyService;
import com.keeping.bankservice.api.service.piggy.dto.AddPiggyDto;
import com.keeping.bankservice.api.service.piggy.dto.ShowPiggyDto;
import com.keeping.bankservice.api.service.piggy_history.dto.AddPiggyHistoryDto;
import com.keeping.bankservice.api.service.piggy_history.PiggyHistoryService;
import com.keeping.bankservice.domain.piggy.Piggy;
import com.keeping.bankservice.domain.piggy.repository.PiggyQueryRepository;
import com.keeping.bankservice.domain.piggy.repository.PiggyRepository;
import com.keeping.bankservice.global.exception.NoAuthorizationException;
import com.keeping.bankservice.global.exception.NotFoundException;
import com.keeping.bankservice.global.exception.ServerException;
import com.keeping.bankservice.global.utils.RedisUtils;
import lombok.RequiredArgsConstructor;
import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;

@Service
@Transactional
@RequiredArgsConstructor
public class PiggyServiceImpl implements PiggyService {

    @Value("${file.path.piggy.window}")
    private String piggyWindowPath;
    @Value("${file.path.piggy.linux}")
    private String piggyLinuxPath;

    private final MemberFeignClient memberFeignClient;
    private final NotiFeignClient notiFeignClient;
    private final PiggyRepository piggyRepository;
    private final PiggyQueryRepository piggyQueryRepository;
    private final AccountHistoryService accountHistoryService;
    private final PiggyHistoryService piggyHistoryService;
    //    private final PasswordEncoder passwordEncoder;
    private final RedisUtils redisUtils;

    @Override
    public Long addPiggy(String memberKey, AddPiggyDto dto) throws IOException {
        String piggyAccountNumber = createNewPiggyAccountNumber();

        if (dto.getUploadImage() == null) {
            throw new NotFoundException("404", HttpStatus.NOT_FOUND, "이미지가 존재하지 않습니다.");
        }

        File folder = null;
        String os = System.getProperty("os.name").toLowerCase();

        if (os.contains("win")) {
            folder = new File(piggyWindowPath);
        } else {
            folder = new File(piggyLinuxPath);
        }

        if (folder != null && !folder.exists()) {
            folder.mkdirs();
        }

        MultipartFile file = dto.getUploadImage();
        String originalFileName = file.getOriginalFilename();

        if (!originalFileName.isEmpty()) {
            String saveFileName = UUID.randomUUID().toString() + originalFileName.substring(originalFileName.lastIndexOf("."));

            file.transferTo(new File(folder, saveFileName));

//            Piggy piggy = Piggy.toPiggy(memberKey, piggyAccountNumber, dto.getContent(), dto.getGoalMoney(), passwordEncoder.encode(dto.getAuthPassword()), originalFileName, saveFileName);
            Piggy piggy = Piggy.toPiggy(memberKey, piggyAccountNumber, dto.getContent(), dto.getGoalMoney(), originalFileName, saveFileName);
            Piggy savePiggy = piggyRepository.save(piggy);

            String parentKey = memberFeignClient.getParentMemberKey(memberKey).getResultBody();
            String name = memberFeignClient.getMemberName(memberKey).getResultBody();

            notiFeignClient.sendNoti(memberKey, SendNotiRequest.builder()
                    .memberKey(parentKey)
                    .title("️저금통 등록!! 🐷")
                    .content(name + " 님이 " + dto.getContent() + " 저금통 챌린지를 시작했어요!")
                    .type("ACCOUNT")
                    .build());

            return savePiggy.getId();
        }

        throw new ServerException("503", HttpStatus.SERVICE_UNAVAILABLE, "저금통 개설 과정 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.");
    }

    @Override
    public List<ShowPiggyResponse> showPiggy(String memberKey, String targetKey) throws IOException {
        // TODO: 두 고유 번호가 부모-자식 관계인지 확인하는 부분 필요

        List<ShowPiggyDto> result = piggyQueryRepository.showPiggy(targetKey);

        List<ShowPiggyResponse> response = new ArrayList<>();

        for (ShowPiggyDto dto : result) {
            File file = null;
            String os = System.getProperty("os.name").toLowerCase();

            if (os.contains("win")) {
                file = new File(piggyWindowPath + "\\" + dto.getSavedImage());
            } else {
                file = new File(piggyLinuxPath + "/" + dto.getSavedImage());

            }

            byte[] byteImage = new byte[(int) file.length()];
            FileInputStream fis = new FileInputStream(file);
            fis.read(byteImage);
            String base64Image = new String(Base64.encodeBase64(byteImage));

            ShowPiggyResponse piggyResponse = ShowPiggyResponse.toResponse(dto, base64Image);
            response.add(piggyResponse);
        }

        return response;
    }

    @Override
    public ShowPiggyResponse showDetailPiggy(String memberKey, String targetKey, Long piggyId) throws IOException {
        // TODO: 두 고유 번호가 부모-자식 관계인지 확인하는 부분 필요

        Piggy piggy = piggyRepository.findById(piggyId)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 저금통이 존재하지 않습니다."));

        if (!piggy.getChildKey().equals(targetKey)) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "접근 권한이 없습니다.");
        }

        File file = null;
        String os = System.getProperty("os.name").toLowerCase();

        if (os.contains("win")) {
            file = new File(piggyWindowPath + "\\" + piggy.getSavedImage());
        } else {
            file = new File(piggyLinuxPath + "/" + piggy.getSavedImage());
        }

        byte[] byteImage = new byte[(int) file.length()];
        FileInputStream fis = new FileInputStream(file);
        fis.read(byteImage);
        String base64Image = new String(Base64.encodeBase64(byteImage));

        ShowPiggyResponse response = ShowPiggyResponse.toResponse(piggy, base64Image);

        return response;
    }

    @Override
    public SavingPiggyResponse savingPiggy(String memberKey, SavingPiggyDto dto) throws URISyntaxException, IOException {
        Piggy piggy = piggyRepository.findByAccountNumber(dto.getPiggyAccountNumber())
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 저금통이 존재하지 않습니다."));

        if (!piggy.getAccountNumber().equals(dto.getPiggyAccountNumber())) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "접근 권한이 없습니다.");
        }

        // TODO: authPassword 일치하는지 확인하는 부분 필요
        // TODO: WithdrawMoney service 제거

        // 출금 거래내역을 등록하는 코드
        AddAccountHistoryDto addAccountHistoryDto = AddAccountHistoryDto.toDto(dto.getAccountNumber(), "저금통 저금", false, Long.valueOf(dto.getMoney()), "");
        accountHistoryService.addAccountHistory(memberKey, addAccountHistoryDto);

        // 저금통 잔액 갱신 코드
        int balance = piggy.getBalance() + dto.getMoney();
        piggy.updateBalance(dto.getMoney());

        // 저금통 저금 내역을 등록하는 코드
        AddPiggyHistoryDto addPiggyHistoryDto = AddPiggyHistoryDto.toDto(piggy, dto.getMoney(), balance);
        piggyHistoryService.addPiggyHistory(memberKey, addPiggyHistoryDto);


        // 목표 금액을 채웠을 때
        if (balance >= piggy.getGoalMoney()) {
            addAccountHistoryDto = AddAccountHistoryDto.toDto(dto.getAccountNumber(), "저금통 성공", true, Long.valueOf(piggy.getBalance()), "");
            accountHistoryService.addAccountHistory(memberKey, addAccountHistoryDto);

            piggy.updateCompleted();
            piggy.updateBalance(0);


            File file = null;
            String os = System.getProperty("os.name").toLowerCase();

            if (os.contains("win")) {
                file = new File(piggyWindowPath + "\\" + piggy.getSavedImage());
            } else {
                file = new File(piggyLinuxPath + "/" + piggy.getSavedImage());
            }

            byte[] byteImage = new byte[(int) file.length()];
            FileInputStream fis = new FileInputStream(file);
            fis.read(byteImage);
            String base64Image = new String(Base64.encodeBase64(byteImage));

            ShowPiggyResponse showPiggyResponse = ShowPiggyResponse.toResponse(piggy, base64Image);
            SavingPiggyResponse response = SavingPiggyResponse.toResponse(true, showPiggyResponse);

            notiFeignClient.sendNoti(memberKey, SendNotiRequest.builder()
                    .memberKey(memberKey)
                    .title("저금통 성공!️! 🎉")
                    .content(piggy.getContent() + " 저금통 챌린지를 성공했습니다!")
                    .type("ACCOUNT")
                    .build());

            String parentKey = memberFeignClient.getParentMemberKey(memberKey).getResultBody();
            String name = memberFeignClient.getMemberName(memberKey).getResultBody();

            notiFeignClient.sendNoti(memberKey, SendNotiRequest.builder()
                    .memberKey(parentKey)
                    .title("저금통 성공!️! 🎉")
                    .content(name + " 님이 " + piggy.getContent() + " 저금통 챌린지를 성공했습니다!")
                    .type("ACCOUNT")
                    .build());

            return response;
        }

        return SavingPiggyResponse.toResponse(false, null);
    }

    // TODO: 없애기
    @Override
    public Piggy isValidPiggy(String memberKey, Long piggyId) {
        Piggy piggy = piggyRepository.findById(piggyId)
                .orElseThrow(() -> new NotFoundException("404", HttpStatus.NOT_FOUND, "해당하는 저금통이 존재하지 않습니다."));

        if (!piggy.getChildKey().equals(memberKey)) {
            throw new NoAuthorizationException("401", HttpStatus.UNAUTHORIZED, "접근 권한이 없습니다.");
        }

        return piggy;
    }

    private String createNewPiggyAccountNumber() throws JsonProcessingException {
        Random rand = new Random();

        int num = 0;
        do {
            num = rand.nextInt(888889) + 111111;
        }
        while (redisUtils.getRedisValue("Piggy_" + String.valueOf(num), String.class) != null);

        String randomNumber = String.valueOf(num);
        redisUtils.setRedisValue("Piggy_" + randomNumber, "1");

        String validCode = "";

        int divideNum = num;
        for (int i = 0; i < 3; i++) {
            int num1 = divideNum % 10;
            divideNum /= 10;
            int num2 = divideNum % 10;

            int sum = 0;
            if (i == 1) {
                sum = (num1 * num2) % 10;
            } else {
                sum = (num1 + num2) % 10;
            }
            divideNum /= 10;

            validCode = String.valueOf(sum) + validCode;
        }

        return "172-" + randomNumber + "-" + validCode + "-27"; // 3-6-3-2
    }
}
