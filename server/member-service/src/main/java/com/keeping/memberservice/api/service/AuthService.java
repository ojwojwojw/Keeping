package com.keeping.memberservice.api.service;

import com.keeping.memberservice.api.controller.NotiFeignClient;
import com.keeping.memberservice.api.controller.request.SendNotiRequest;
import com.keeping.memberservice.api.controller.response.LinkcodeResponse;
import com.keeping.memberservice.api.service.member.MemberService;
import com.keeping.memberservice.api.service.member.dto.LinkResultDto;
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
    private final NotiFeignClient notiFeignClient;
    private final MemberService memberService;
    private static final String CERTIFICATION_REQUEST = "certification_request";
    private static final long CERTIFICATION_NUMBER_EXPIRE = 200;
    private static final long ONE_DAY = 86400;
    private static final String VERIFIED_NUMBER = "verified_number_";
    private static final String WFC = "WAITING_FOR_CONNECTION_";
    private static final String IL = "I_LINK_";

    /**
     * 내가 링크했는지 확인
     *
     * @param memberKey
     * @return
     */
    public boolean doILink(String memberKey) {
        return Boolean.TRUE.equals(redisTemplate.hasKey(IL + memberKey));
    }

    /**
     * 누가 나를 링크했나
     *
     * @param memberKey
     * @param linkCode
     * @return
     */
    public String whoLinkMe(String memberKey, String linkCode) {
        return redisTemplate.opsForValue().get(WFC + linkCode);
    }


    /**
     * 연결하기
     *
     * @param yourLinkCode 상대코드
     * @param myMemberKey
     * @param myType
     * @return 결과
     */
    public LinkResultDto link(String yourLinkCode, String myMemberKey, String myType) {
        // 인증번호 유효한지 확인
        String yourType = myType.equals("parent") ? "child" : "parent";
        log.debug("[연결] 나 = {}, 너 = {}", myType, yourType);
        String yourKeyWithCode = createLinkCodeKey(yourType, yourLinkCode);
        if (Boolean.FALSE.equals(redisTemplate.hasKey(yourKeyWithCode))) {
            log.debug("[연결] 너의 연결코드 = {} 없음", yourLinkCode);
            return LinkResultDto.builder()
                    .success(false)
                    .failMessage("일치하는 인증번호가 없습니다.")
                    .build();
        }

        // 상대 연결 코드가 사용 가능한지 확인
        String yourOpponentMemberKey = redisTemplate.opsForValue().get(WFC + yourLinkCode);
        if (yourOpponentMemberKey != null && !yourOpponentMemberKey.equals(myMemberKey)) {
            log.debug("[연결] 상대방이 다른사람 = {} 과 연결 시도중, 나는 = {}", yourOpponentMemberKey, myMemberKey);
            return LinkResultDto.builder()
                    .success(false)
                    .failMessage("상대방이 다른 사람과 연결을 시도 중 입니다.")
                    .build();
        }

        String yourMemberKey = redisTemplate.opsForValue().get(yourKeyWithCode);
        String linkKey;
        if (myType.equals("parent")) {
            linkKey = getLinkKey(myMemberKey, yourMemberKey);
        } else {
            linkKey = getLinkKey(yourMemberKey, myMemberKey);
        }

        if (Boolean.TRUE.equals(redisTemplate.hasKey(linkKey))) {
            log.debug("[연결] 상대가 먼저 연결했음");
            deleteLinkCodeKey(myMemberKey, myType);
            deleteLinkCodeKey(yourMemberKey, yourType);
            redisTemplate.delete(linkKey);
            redisTemplate.delete(IL + yourMemberKey);

            String myName = memberService.getMemberName(myMemberKey);
            notiFeignClient.sendNoti(myMemberKey, SendNotiRequest.builder()
                    .memberKey(yourMemberKey)
                    .title("연결이 되었습니다 😆")
                    .content(myName + "님과 연결이 완료되었습니다!")
                    .type("MEMBER")
                    .build());

            return LinkResultDto.builder()
                    .success(true)
                    .partner(yourMemberKey)
                    .relation(yourType)
                    .build();
        } else {
            redisStringInsert(linkKey, "ok", ONE_DAY);
            String key = createLinkCodeKey(myType, myMemberKey);
            Long expire = redisTemplate.getExpire(key);
            // 연결 대기중 키 넣기
            String myCode = redisTemplate.opsForValue().get(createLinkCodeKey(myType, myMemberKey));
            redisStringInsert(WFC + myCode, yourMemberKey, ONE_DAY);
            redisStringInsert(WFC + yourLinkCode, myMemberKey, ONE_DAY);
            redisStringInsert(IL + myMemberKey, "ok", ONE_DAY);
            redisTemplate.expire(key, ONE_DAY, TimeUnit.SECONDS);

            String myName = memberService.getMemberName(myMemberKey);
            notiFeignClient.sendNoti(myMemberKey, SendNotiRequest.builder()
                    .memberKey(yourMemberKey)
                    .title("누군가 연결을 시도중이에요😆")
                    .content(myName + "님이 연결을 시도 중 입니다!")
                    .type("MEMBER")
                    .build());

            return LinkResultDto.builder()
                    .success(false)
                    .failMessage("상대방의 연결을 대기중입니다.")
                    .expire(Math.toIntExact(ONE_DAY))
                    .build();
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
        String linkCode = createRandomNumCode();
        String linkCodeKey = createLinkCodeKey(type, linkCode);
        String linkCodeMemberKey = createLinkCodeKey(type, memberKey);
        String oldKey = redisTemplate.opsForValue().get(linkCodeMemberKey);
        if (oldKey != null) {
            redisTemplate.delete(oldKey);
        }
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
        redisTemplate.delete(key);
        redisTemplate.opsForValue().append(key, value);
        redisTemplate.expire(key, expire, TimeUnit.SECONDS);
    }

    private void deleteLinkCodeKey(String memberKey, String type) {
        String myKey = createLinkCodeKey(type, memberKey);
        String myCode = redisTemplate.opsForValue().get(myKey);
        String myCodeKey = createLinkCodeKey(type, myCode);
        redisTemplate.delete(myCodeKey);
        redisTemplate.delete(myKey);
        redisTemplate.delete(WFC + myCode);
    }
}
