package com.completionism.keeping.api.service.piggy.impl;

import com.completionism.keeping.api.controller.piggy.response.ShowPiggyResponse;
import com.completionism.keeping.api.service.piggy.PiggyService;
import com.completionism.keeping.api.service.piggy.dto.AddPiggyDto;
import com.completionism.keeping.api.service.piggy.dto.ShowPiggyDto;
import com.completionism.keeping.domain.piggy.Piggy;
import com.completionism.keeping.domain.piggy.repository.PiggyQueryRepository;
import com.completionism.keeping.domain.piggy.repository.PiggyRepository;
import com.completionism.keeping.global.exception.NotFoundException;
import com.completionism.keeping.global.exception.ServerException;
import com.completionism.keeping.global.utils.RedisUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;

@Service
@Transactional
@RequiredArgsConstructor
public class PiggyServiceImpl implements PiggyService {

    @Value("${file.path.piggy}")
    private String piggyPath;

    private final PiggyRepository piggyRepository;
    private final PiggyQueryRepository piggyQueryRepository;
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

    @Override
    public List<ShowPiggyResponse> showPiggy(String memberKey) throws IOException {
        List<ShowPiggyDto> result = piggyQueryRepository.showPiggy(memberKey);

        List<ShowPiggyResponse> response = new ArrayList<>();

        for(ShowPiggyDto dto: result) {
            InputStream in = new FileInputStream(piggyPath + "\\" + dto.getSavedImage());
            ShowPiggyResponse piggyResponse = ShowPiggyResponse.toResponse(dto, IOUtils.toByteArray(in));

            response.add(piggyResponse);
        }

        return response;
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
