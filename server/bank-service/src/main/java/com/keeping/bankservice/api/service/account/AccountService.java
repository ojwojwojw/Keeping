package com.keeping.bankservice.api.service.account;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.bankservice.api.service.account.dto.AddAccountDto;
import com.keeping.bankservice.api.service.account.dto.AuthPhoneDto;
import com.keeping.bankservice.api.service.account.dto.CheckPhoneDto;
import org.springframework.transaction.annotation.Transactional;

import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

@Transactional
public interface AccountService {
    Long addAccount(String memberKey, AddAccountDto dto) throws JsonProcessingException;
    void checkPhone(String memberKey, CheckPhoneDto dto) throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException, InvalidKeyException, JsonProcessingException;
    void authPhone(String memberKey, AuthPhoneDto dto) throws JsonProcessingException;
}
