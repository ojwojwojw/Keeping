package com.keeping.questionservice.global.config;

import feign.RetryableException;
import feign.Retryer;

public class CustomRetryer implements Retryer {
    private final int maxAttempts;
    private final long backoff;
    private int attempt;

    public CustomRetryer() {
        this(3, 20000); // 최대 3번 재시도, 20초마다 재시도
    }

    public CustomRetryer(int maxAttempts, long backoff) {
        this.maxAttempts = maxAttempts;
        this.backoff = backoff;
        this.attempt = 1;
    }

    @Override
    public void continueOrPropagate(RetryableException e) {
        if (attempt++ >= maxAttempts) {
            throw e;
        }
        try {
            Thread.sleep(backoff);
        } catch (InterruptedException ignored) {
            Thread.currentThread().interrupt();
        }
    }
    @Override
    public Retryer clone() {
        return new CustomRetryer(maxAttempts, backoff);
    }
}
