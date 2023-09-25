package com.keeping.memberservice.api.service;

import com.keeping.memberservice.api.controller.response.LinkResultResponse;
import com.keeping.memberservice.api.controller.response.LinkcodeResponse;
import com.keeping.memberservice.domain.Link;
import com.keeping.memberservice.domain.repository.ChildRepository;
import com.keeping.memberservice.domain.repository.LinkRepository;
import com.keeping.memberservice.domain.repository.ParentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@RequiredArgsConstructor
@Service
@Transactional(readOnly = true)
@Slf4j
public class AuthService {

    private final RedisTemplate<String, String> redisTemplate;
    private final LinkRepository linkRepository;
    private final ParentRepository parentRepository;
    private final ChildRepository childRepository;
    private static final String CERTIFICATION_REQUEST = "certification_request";
    private static final long CERTIFICATION_NUMBER_EXPIRE = 200;
    private static final long ONE_DAY = 86400;
    private static final String VERIFIED_NUMBER = "verified_number_";

    /**
     * 연결하기
     *
     * @param linkcode  상대코드
     * @param memberKey
     * @param type
     * @return 결과
     */
    public LinkResultResponse link(String linkcode, String memberKey, String type) {
        String partnerType = type.equals("parent") ? "child" : "parent";
        String partnerCodeKey = createLinkCodeKey(partnerType, linkcode);
        if (Boolean.FALSE.equals(redisTemplate.hasKey(partnerCodeKey))) {
            return "일치하는 인증번호가 없습니다.";
        }

        String partnerMemberKey = redisTemplate.opsForValue().get(partnerCodeKey);
        String linkKey;
        if (type.equals("parent")) {
            linkKey = getLinkKey(memberKey, partnerMemberKey);
        } else {
            linkKey = getLinkKey(partnerMemberKey, memberKey);
        }

        if (Boolean.TRUE.equals(redisTemplate.hasKey(linkKey))) {
            deleteLinkCodeKey(memberKey, type);
            deleteLinkCodeKey(partnerMemberKey, partnerType);
            redisTemplate.delete(linkKey);

            return partnerMemberKey;
        } else {
            redisStringInsert(linkKey, "ok", ONE_DAY);
            return "상대방의 연결을 대기중입니다.";
        }
    }

    /**
     * 연결코드+만료시간 반환
     *
     * @param memberKey
     * @param type
     * @return
     */
    public LinkcodeResponse getLinkCode(String memberKey, String type) {
        String key = createLinkCodeKey(type, memberKey);
        Long expire = redisTemplate.getExpire(key);
        if (expire == null || expire < 0) {
            return null;
        }
        String linkCode = redisTemplate.opsForValue().get(key);
        return createLinkCodeResponse(expire, linkCode);
    }

    /**
     * 연결코드 생성
     *
     * @param type      부모/자녀
     * @param memberKey 식별
     * @return 연결코드
     */
    public String createLinkCode(String type, String memberKey) {
        ValueOperations<String, String> redisString = redisTemplate.opsForValue();

        String linkCode = createRandomNumCode();
        String linkCodeKey = createLinkCodeKey(type, linkCode);
        String linkCodeMemberKey = createLinkCodeKey(type, memberKey);
        redisStringInsert(linkCodeKey, memberKey, ONE_DAY);
        redisStringInsert(linkCodeMemberKey, linkCode, ONE_DAY);
        return linkCode;
    }

    /**
     * 번호인증이 되었는지 확인하는 함수
     *
     * @param phone 전화번호
     * @return 인증됨 = true;
     */
    public boolean joinUserConfirm(String phone) {
        ValueOperations<String, String> redisString = redisTemplate.opsForValue();

        String result = redisString.get(VERIFIED_NUMBER + phone);
        log.debug("[번호 인증 확인] 전화번호 = {}, 키 = {}, 결과 = {}", phone, VERIFIED_NUMBER + phone, result);
        return result != null;
    }

    /**
     * 인증번호 검사
     *
     * @param phone         전화번호
     * @param certification 인증번호
     * @return 인증됨 = true
     */
    public boolean checkNumber(String phone, String certification) {
        ValueOperations<String, String> redisString = redisTemplate.opsForValue();

        String certification_request = CERTIFICATION_REQUEST + phone;
        String number = redisString.get(certification_request);
        log.debug("[번호인증] 발급된 번호 = {}, 입력한 번호 ={}", number, certification);
        if (certification == null || !certification.equals(number)) {
            return false;
        }

        String verifiedKey = VERIFIED_NUMBER + phone;

        redisStringInsert(verifiedKey, "ok", CERTIFICATION_NUMBER_EXPIRE);
        return true;
    }

    /**
     * 인증번호 발급
     *
     * @param phone
     * @return
     */
    public String getRandomCertification(String phone) {
        String number = createRandomNumCode();

        String certification_request = CERTIFICATION_REQUEST + phone;
        redisTemplate.delete(certification_request);
        redisStringInsert(certification_request, number, CERTIFICATION_NUMBER_EXPIRE);
        redisTemplate.delete(VERIFIED_NUMBER + phone);
        return number;
    }

    public String createRandomNumCode() {
        Random rand = new Random();
        StringBuilder numStr = new StringBuilder();

        for (int i = 0; i < 6; i++) {
            String ran = String.valueOf(rand.nextInt(10));
            numStr.append(ran);
        }

        return numStr.toString();
    }

    private String createLinkCodeKey(String type, String key) {
        return "LINKCODE_" + type + "_" + key;
    }

    private LinkcodeResponse createLinkCodeResponse(Long expire, String linkCode) {
        return LinkcodeResponse.builder()
                .expire(expire.intValue())
                .linkcode(linkCode)
                .build();
    }

    private String getLinkKey(String parentKey, String childKey) {
        return "link_" + parentKey + "_" + childKey;
    }

    private void redisStringInsert(String key, String value, long expire) {
        redisTemplate.opsForValue().append(key, value);
        redisTemplate.expire(key, expire, TimeUnit.SECONDS);
    }

    private void deleteLinkCodeKey(String memberKey, String type) {
        String myKey = createLinkCodeKey(type, memberKey);
        String myCode = redisTemplate.opsForValue().get(myKey);
        String myCodeKey = createLinkCodeKey(type, myCode);
        redisTemplate.delete(myCodeKey);
        redisTemplate.delete(myKey);
    }
}
