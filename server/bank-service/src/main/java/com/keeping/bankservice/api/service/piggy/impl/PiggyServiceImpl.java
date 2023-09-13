package com.keeping.bankservice.api.service.piggy.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.bankservice.api.service.piggy.PiggyService;
import com.keeping.bankservice.api.service.piggy.dto.AddPiggyDto;
import com.keeping.bankservice.domain.piggy.Piggy;
import com.keeping.bankservice.domain.piggy.repository.PiggyRepository;
import com.keeping.bankservice.global.exception.NotFoundException;
import com.keeping.bankservice.global.exception.ServerException;
import com.keeping.bankservice.global.utils.RedisUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Random;
import java.util.UUID;

@Service
@Transactional
@RequiredArgsConstructor
public class PiggyServiceImpl implements PiggyService {

    @Value("${file.path.piggy}")
    private String piggyPath;

    private final PiggyRepository piggyRepository;
    private final PasswordEncoder passwordEncoder;
    private final RedisUtils redisUtils;

    @Override
    public Long addPiggy(String memberKey, AddPiggyDto dto) throws IOException {
        String piggyAccountNumber = createNewPiggyAccountNumber();

        if(dto.getUploadImage() == null) {
            throw new NotFoundException("404", HttpStatus.NOT_FOUND, "이미지가 존재하지 않습니다.");
        }

        File folder = new File(piggyPath);
        if(!folder.exists()) {
            folder.mkdirs();
        }

        MultipartFile file = dto.getUploadImage();
        String originalFileName = file.getOriginalFilename();

        if(!originalFileName.isEmpty()) {
            String saveFileName = UUID.randomUUID().toString() + originalFileName.substring(originalFileName.lastIndexOf("."));

            file.transferTo(new File(folder, saveFileName));

            Piggy piggy = Piggy.toPiggy(memberKey, piggyAccountNumber, dto.getContent(), dto.getGoalMoney(), passwordEncoder.encode(dto.getAuthPassword()), originalFileName, saveFileName);
            Piggy savePiggy = piggyRepository.save(piggy);

            return savePiggy.getId();
        }

        throw new ServerException("503", HttpStatus.SERVICE_UNAVAILABLE, "저금통 개설 과정 중 문제가 생겼습니다. 잠시 후 다시 시도해 주세요.");
    }

    private String createNewPiggyAccountNumber() throws JsonProcessingException {
        Random rand = new Random();

        int num = 0;
        do {
            num = rand.nextInt(888889) + 111111;
        }
        while(redisUtils.getRedisValue("Piggy_" + String.valueOf(num), String.class) != null);

        String randomNumber = String.valueOf(num);
        redisUtils.setRedisValue("Piggy_" + randomNumber, "1");

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

        return "172-" + randomNumber + "-" + validCode + "-27"; // 3-6-3-2
    }
}
