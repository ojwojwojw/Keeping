package com.keeping.questionservice.global.utils;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.stereotype.Service;

import java.util.Base64;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class RedisUtils {

    private final RedisTemplate<String, String> redisTemplate;
    private final StringRedisTemplate stringRedisTemplate;

    public void setRedisValue(String key, Object o, Long ttl) {
        GenericJackson2JsonRedisSerializer serializer = new GenericJackson2JsonRedisSerializer();

        byte[] serialize = serializer.serialize(o);

        String serializeObject = Base64.getEncoder().encodeToString(serialize);

        redisTemplate.opsForValue().set(key, serializeObject, ttl, TimeUnit.SECONDS);
    }

    public void setRedisValue(String key, Object o) {
        GenericJackson2JsonRedisSerializer serializer = new GenericJackson2JsonRedisSerializer();

        byte[] serialize = serializer.serialize(o);

        String serializeObject = Base64.getEncoder().encodeToString(serialize);

        redisTemplate.opsForValue().set(key, serializeObject);
    }

    public void setRedisHash(String key, String memberKey, String question, Long ttl) {
        HashOperations<String, String, String> hashOperations = stringRedisTemplate.opsForHash();
        hashOperations.put(key, memberKey, question);
        stringRedisTemplate.expire(key, ttl, TimeUnit.SECONDS);
    }

    public <T> T getRedisValue(String key, Class<T> classType) throws JsonProcessingException {
        String redisValue = redisTemplate.opsForValue().get(key);

        if(redisValue == null) {
            return null;
        }

        GenericJackson2JsonRedisSerializer serializer = new GenericJackson2JsonRedisSerializer();

        byte[] decode = Base64.getDecoder().decode(redisValue);

        return serializer.deserialize(decode, classType);
    }

    public Map<String, String> getRedisHash(String key) { // redis DB 정보 가져오기
        HashOperations<String, String, String> hashOperations = stringRedisTemplate.opsForHash();
        return hashOperations.entries(key);
    }

    public void deleteRedisKey(String key, String loginId) {
        HashOperations<String, String, String> hashOperations = stringRedisTemplate.opsForHash();
        hashOperations.delete(key, loginId);
    }
}