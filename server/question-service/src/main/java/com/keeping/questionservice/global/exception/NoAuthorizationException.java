package com.keeping.questionservice.global.exception;

import org.springframework.http.HttpStatus;

public class NoAuthorizationException extends ServiceRuntimeException {
    public NoAuthorizationException(String resultCode, HttpStatus httpStatus, String resultMessage) {
        super(resultCode, httpStatus, resultMessage);
    }

    public String getResultCode() { return super.getResultCode(); }

    public HttpStatus getHttpStatus() { return super.getHttpStatus(); }

    public String getResultMessage() { return super.getResultMessage(); }
}
