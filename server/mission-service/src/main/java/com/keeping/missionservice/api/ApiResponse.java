package com.keeping.missionservice.api;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class ApiResponse<T> {
    
    private DataHeader resultStatus;
    private T resultBody;

    public ApiResponse(DataHeader resultStatus, T resultBody) {
        this.resultStatus = resultStatus;
        this.resultBody = resultBody;
    }

    public static <T> ApiResponse<T> of(int successCode, HttpStatus status, String resultMessage, T data) {
        return new ApiResponse<>(new DataHeader(successCode, String.valueOf(status.value()), resultMessage), data);
    }

    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(new DataHeader(0, "", ""), data);
    }
}
