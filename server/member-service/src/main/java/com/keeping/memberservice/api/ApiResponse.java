package com.keeping.memberservice.api;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class ApiResponse<T> {

    private DataHeader resultStatus;
    private T resultBody;

    public ApiResponse(DataHeader dataHeader, T dataBody) {
        this.resultStatus = dataHeader;
        this.resultBody = dataBody;
    }

    public static <T> ApiResponse<T> of(int successCode, HttpStatus status, String resultMessage) {
        return new ApiResponse<>(new DataHeader(successCode, String.valueOf(status.value()), resultMessage), null);
    }

    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(new DataHeader(0, "", ""), data);
    }
}
