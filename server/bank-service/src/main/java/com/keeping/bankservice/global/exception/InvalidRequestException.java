package com.keeping.bankservice.global.exception;

import org.springframework.http.HttpStatus;

public class InvalidRequestException extends ServiceRuntimeException {
    public InvalidRequestException(String resultCode, HttpStatus httpStatus, String resultMessage) {
        super(resultCode, httpStatus, resultMessage);
    }

    public String getResultCode() { return super.getResultCode(); }

    public HttpStatus getHttpStatus() { return super.getHttpStatus(); }

    public String getResultMessage() { return super.getResultMessage(); }
}
