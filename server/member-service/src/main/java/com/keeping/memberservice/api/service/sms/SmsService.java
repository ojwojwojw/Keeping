//package com.keeping.memberservice.api.service.sms;
//
//import com.completionism.keeping.api.service.sms.dto.MessageDto;
//import com.completionism.keeping.api.service.sms.dto.SmsResponseDto;
//import com.fasterxml.jackson.core.JsonProcessingException;
//
//import java.io.UnsupportedEncodingException;
//import java.net.URISyntaxException;
//import java.security.InvalidKeyException;
//import java.security.NoSuchAlgorithmException;
//
//public interface SmsService {
//    String makeSignature(Long time) throws NoSuchAlgorithmException, UnsupportedEncodingException, InvalidKeyException;
//    SmsResponseDto sendSmsMessage(MessageDto dto) throws UnsupportedEncodingException, NoSuchAlgorithmException, InvalidKeyException, JsonProcessingException, URISyntaxException;
//}
