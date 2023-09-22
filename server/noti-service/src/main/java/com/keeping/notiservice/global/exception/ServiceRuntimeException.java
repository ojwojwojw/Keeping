package com.keeping.notiservice.global.exception;

import org.springframework.http.HttpStatus;

public class ServiceRuntimeException extends RuntimeException {
    private String resultCode;
    private HttpStatus httpStatus;
    private String resultMessage;


    public ServiceRuntimeException(String resultCode, HttpStatus httpStatus, String resultMessage) {
        this.resultCode = resultCode;
        this.httpStatus = httpStatus;
        this.resultMessage = resultMessage;
    }

    public String getResultCode() { return resultCode; }

    public HttpStatus getHttpStatus() { return httpStatus; }

    public String getResultMessage() { return resultMessage; }
}
