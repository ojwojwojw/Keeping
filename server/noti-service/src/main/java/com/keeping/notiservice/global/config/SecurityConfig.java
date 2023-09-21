package com.keeping.notiservice.global.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.csrf().disable();

        http.authorizeRequests()
                .antMatchers( "/health-check", "/actuator/**").permitAll()
                .antMatchers("/**").permitAll();
//                .antMatchers("/**").hasIpAddress(env.getProperty("gateway.ip"))

        http.headers().frameOptions().disable();

        return http.build();
    }
}