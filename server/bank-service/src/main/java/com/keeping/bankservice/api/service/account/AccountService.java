package com.keeping.bankservice.api.service.account;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.keeping.bankservice.api.controller.account.response.AddAccountResponse;
import com.keeping.bankservice.api.controller.account.response.ShowAccountResponse;
import com.keeping.bankservice.api.service.account.dto.*;
import com.keeping.bankservice.domain.account.Account;
import org.springframework.transaction.annotation.Transactional;

import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

@Transactional
public interface AccountService {
    AddAccountResponse addAccount(String memberKey, AddAccountDto dto) throws JsonProcessingException;
    void checkPhone(String memberKey, CheckPhoneDto dto) throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException, InvalidKeyException, JsonProcessingException;
    void authPhone(String memberKey, AuthPhoneDto dto) throws JsonProcessingException;
    Account withdrawMoney(String memberKey, WithdrawMoneyDto dto);
    Account depositMoney(String memberKey, DepositMoneyDto dto);
    ShowAccountResponse showAccount(String memberKey, String targetKey);
    Long showBalance(String memberKey);
}
