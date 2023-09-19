package com.keeping.missionservice.api;

import lombok.Getter;

@Getter
public class DataHeader {
    
    private int successCode;
    private String resultCode;
    private String resultMessage;

    public DataHeader(int successCode, String resultCode, String resultMessage) {
        this.successCode = successCode;
        this.resultCode = resultCode;
        this.resultMessage = resultMessage;
    }
}
