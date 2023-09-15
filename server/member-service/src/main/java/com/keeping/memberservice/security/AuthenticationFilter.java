package com.keeping.memberservice.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.keeping.memberservice.api.controller.request.LoginRequest;
import com.keeping.memberservice.api.service.member.MemberService;
import com.keeping.memberservice.domain.Member;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.env.Environment;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import javax.servlet.FilterChain;
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
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authResult) {
        String username = ((User) authResult.getPrincipal()).getUsername();
        Member member = memberService.getUserDetailsByLoginId(username);

        String token = Jwts.builder()
            .setSubject(member.getMemberKey())
            .setExpiration(new Date(System.currentTimeMillis() + 86400000))
            .signWith(key, SignatureAlgorithm.HS256)
            .compact();

        response.addHeader("token", token);
        response.addHeader("memberKey", member.getMemberKey());
    }
}
