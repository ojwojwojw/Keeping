package com.completionism.keeping.api;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class ApiResponse<T> {
    
    private ResultStatus resultStatus;
    private T resultBody;

    public ApiResponse(ResultStatus resultStatus, T resultBody) {
        this.resultStatus = resultStatus;
        this.resultBody = resultBody;
    }

    public static <T> ApiResponse<T> of(int successCode, HttpStatus status, String resultMessage, T data) {
        return new ApiResponse<>(new ResultStatus(successCode, String.valueOf(status.value()), resultMessage), data);
    }

    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(new ResultStatus(0, "", ""), data);
    }
}
