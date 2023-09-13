package com.keeping.bankservice.piggy;

import com.keeping.bankservice.api.controller.piggy.request.AddPiggyRequest;
import com.keeping.bankservice.api.service.piggy.PiggyService;
import com.keeping.bankservice.api.service.piggy.dto.AddPiggyDto;
import com.keeping.bankservice.domain.piggy.repository.PiggyRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
@Transactional
public class PiggyServiceTest {

    @Autowired
    PiggyService piggyService;
    @Autowired
    PiggyRepository piggyRepository;

    @Test
    @DisplayName("저금통 생성")
    void addPiggy() throws IOException {
        // given
        String memberKey = "0986724";

        String fileName = "짱구"; // 파일명
        String contentType = "jpg"; // 파일타입
        String filePath = "src/test/resources/testImage/"+fileName+"."+contentType; // 파일 경로
        FileInputStream fileInputStream = new FileInputStream(filePath);

        MultipartFile image = new MockMultipartFile(
                "images", // name
                fileName + "." + contentType, // originalFilename
                contentType,
                fileInputStream
        );

        AddPiggyRequest request = AddPiggyRequest.builder()
                .content("모니터")
                .goalMoney(400000)
                .authPassword("123456")
                .uploadImage(image)
                .build();

        // when
        AddPiggyDto dto = AddPiggyDto.toDto(request);
        Long piggyId = piggyService.addPiggy(memberKey, dto);

        // then
        assertNotNull(piggyId);
    }
}
