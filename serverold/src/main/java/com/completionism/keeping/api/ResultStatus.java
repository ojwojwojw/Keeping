package com.completionism.keeping.api;

import lombok.Getter;

@Getter
public class ResultStatus {
    
    private int successCode;
    private String resultCode;
    private String resultMessage;

    public ResultStatus(int successCode, String resultCode, String resultMessage) {
        this.successCode = successCode;
        this.resultCode = resultCode;
        this.resultMessage = resultMessage;
    }
}
