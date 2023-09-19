package com.keeping.bankservice.piggy;

import com.keeping.bankservice.api.controller.piggy.request.AddPiggyRequest;
import com.keeping.bankservice.api.controller.piggy.response.ShowPiggyResponse;
import com.keeping.bankservice.api.service.piggy.PiggyService;
import com.keeping.bankservice.api.service.piggy.dto.AddPiggyDto;
import com.keeping.bankservice.domain.piggy.Piggy;
import com.keeping.bankservice.domain.piggy.repository.PiggyRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.util.List;

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

        String fileName = "짱구1"; // 파일명
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

    @Test
    @DisplayName("저금통 전체 조회")
    void searchPiggy() throws IOException {
        // given
        String memberKey = "0986724";
        insertPiggy(memberKey);

        // when
        List<ShowPiggyResponse> response = piggyService.showPiggy(memberKey);

        // then
        assertNotNull(response);
    }

    private void insertPiggy(String childKey) throws IOException {
        for(int i = 1; i <= 5; i++) {
            String fileName = "짱구" + i; // 파일명
            String contentType = "jpg"; // 파일타입
            String filePath = "src/test/resources/testImage/"+fileName+"."+contentType; // 파일 경로
            FileInputStream fileInputStream = new FileInputStream(filePath);

            MultipartFile image = new MockMultipartFile(
                    "images", // name
                    fileName + "." + contentType, // originalFilename
                    contentType,
                    fileInputStream
            );

            AddPiggyDto dto = AddPiggyDto.builder()
                    .content("내용 " + i)
                    .goalMoney(50000)
                    .authPassword("123456")
                    .uploadImage(image)
                    .build();

            piggyService.addPiggy(childKey, dto);
        }
    }
}
