package com.keeping.notiservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;

import javax.annotation.PostConstruct;
import java.util.TimeZone;

@EnableFeignClients
@EnableScheduling
@EnableDiscoveryClient
@EnableJpaAuditing
@SpringBootApplication
public class NotiServiceApplication {


    @PostConstruct
    public void started() {
        // timezone 세팅
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Seoul"));
    }

    public static void main(String[] args) {
        SpringApplication.run(NotiServiceApplication.class, args);
    }

}
