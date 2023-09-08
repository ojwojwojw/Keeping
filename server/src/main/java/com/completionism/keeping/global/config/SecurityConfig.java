package com.completionism.keeping.global.config;

import com.completionism.keeping.global.jwt.JwtAuthenticationFilter;
import com.completionism.keeping.global.jwt.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;


@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtTokenProvider jwtTokenProvider;

    // TODO: 2023-09-08 인증 필요없는 url들 추가해 주세요!
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .cors()
                .and()
                .csrf().disable() // rest api이므로 csrf 보안이 필요없으므로 disable 처리
                .httpBasic().disable() // httpBasic 방식 대신에 JWT 방식을 사용하므로 disable로 설정
                .headers().frameOptions().sameOrigin()
                .and()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS) // JWT를 사용하기 때문에 session을 stateless로 설정한다. stateless로 설정 시 Spring Security는 세션을 사용하지 않는다.
                .and()
                .authorizeRequests() // 요청 url에 따라 접근 권한 설정
                  .antMatchers("/api/auth/**").permitAll()// /아래 모든 리소스의 접근을 인증절차 없이 허용한다
                  .anyRequest().authenticated() // 인증된 유저만 접근 허용
                .and()
                .addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider), UsernamePasswordAuthenticationFilter.class); // UsernamePasswordAuthenticationFilter: 아이디, 패스워드 기반의 인증을 담당하는 필터

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        // 단방향 비밀번호 암호화
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }
}
