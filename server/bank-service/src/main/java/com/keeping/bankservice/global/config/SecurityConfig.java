package com.keeping.bankservice.global.config;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.actuate.autoconfigure.security.servlet.EndpointRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;


@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        // 단방향 비밀번호 암호화
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.csrf().disable();

        http.authorizeRequests()
                    .antMatchers("/actuator/**").permitAll() // Actuator 엔드포인트에 대한 모든 요청 허용
                    .anyRequest().authenticated()
                .and()
                    .httpBasic();
//                .antMatchers("/**").hasIpAddress(env.getProperty("gateway.ip"))

        http.headers().frameOptions().disable();

        return http.build();
    }
}
