package com.completionism.keeping.sample.redis;

import com.completionism.keeping.global.utils.RedisUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@Transactional
public class RedisSampleTest {

    @Autowired
    RedisUtils redisUtils;

    @Test
    @DisplayName("레디스 샘플 코드")
    void redisSampleTest() throws JsonProcessingException {
        // given
        String key = "hello";
        String value = "hello_world";

        // when
        redisUtils.setRedisValue(key, value);

        // then
        System.out.println("hello: " + redisUtils.getRedisValue(key, String.class));
        System.out.println("hello1: " + redisUtils.getRedisValue("hello1", String.class));
    }
}
