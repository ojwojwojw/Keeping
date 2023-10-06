package com.keeping.memberservice.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.keeping.memberservice.api.ApiResponse;
import com.keeping.memberservice.api.controller.request.LoginRequest;
import com.keeping.memberservice.api.service.member.MemberService;
import com.keeping.memberservice.domain.Member;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Key;
import java.util.ArrayList;
import java.util.Date;

@Slf4j
public class AuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    private final MemberService memberService;
    private final Environment env;
    private final Key key;

    public AuthenticationFilter(AuthenticationManager authenticationManager, MemberService memberService, Environment env) {
        super.setAuthenticationManager(authenticationManager);
        this.memberService = memberService;
        this.env = env;
        byte[] keyBytes = Decoders.BASE64.decode(this.env.getProperty("jwt.secret"));
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        try {
            LoginRequest creds = new ObjectMapper().readValue(request.getInputStream(), LoginRequest.class);

            return getAuthenticationManager()
                    .authenticate(new UsernamePasswordAuthenticationToken(creds.getLoginId(), creds.getLoginPw(), new ArrayList<>()));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) throws IOException, ServletException {
//        super.unsuccessfulAuthentication(request, response, failed);
        setResponse(response, false);
    }

    @Override
    protected void successfulAuthentication(HttpServletRequest request,
                                            HttpServletResponse response,
                                            FilterChain chain,
                                            Authentication authResult) throws IOException {
        String username = ((User) authResult.getPrincipal()).getUsername();
        Member member = memberService.getUserDetailsByLoginId(username);

        String token = Jwts.builder()
                .setSubject(member.getMemberKey())
                .setExpiration(new Date(System.currentTimeMillis() + 86400000))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();

        response.addHeader("token", token);
        response.addHeader("memberKey", member.getMemberKey());

        setResponse(response, true);
    }

    private void setResponse(HttpServletResponse response, boolean result) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("utf-8");

        ObjectMapper objectMapper = new ObjectMapper();

        ApiResponse<String> loginResponse;

        if (result) {
            loginResponse = ApiResponse.ok("로그인 성공");
        } else {
            loginResponse = ApiResponse.of(1, HttpStatus.BAD_REQUEST, "아이디 혹은 비밀번호를 확인하세요.");
        }
        String login = objectMapper.writeValueAsString(loginResponse);

        response.getWriter().write(login);
    }
}
