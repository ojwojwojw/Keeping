package com.keeping.apigatewayservice.filter;

import io.jsonwebtoken.Jwts;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Component
@Slf4j
public class AuthorizationHeaderFilter extends AbstractGatewayFilterFactory<AuthorizationHeaderFilter.Config> {

    private final Environment env;

    public AuthorizationHeaderFilter(Environment env) {
        super(Config.class);
        this.env = env;
    }

    public static class Config {

    }

    @Override
    public GatewayFilter apply(Config config) {
        return ((exchange, chain) -> {
            ServerHttpRequest request = exchange.getRequest();

            log.debug("[게이트웨이 실행]");
            if (!request.getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
                return onError(exchange, "No authorization header", HttpStatus.UNAUTHORIZED);
            }

            String authorizationHeader = request.getHeaders().get(HttpHeaders.AUTHORIZATION).get(0);
            String jwt = authorizationHeader.replace("Bearer", "");
            log.debug("[게이트웨이] jwt = {}", jwt);

            String memberKey = getMemberKey(exchange);

            if (!isJwtValid(jwt, memberKey)) {
                return onError(exchange, "JWT token is not valid", HttpStatus.UNAUTHORIZED);
            }
            log.debug("[게이트웨이 통과]");

            return chain.filter(exchange);
        });
    }

    private Mono<Void> onError(ServerWebExchange exchange, String err, HttpStatus httpStatus) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(httpStatus);

        log.error(err);
        return response.setComplete();
    }

    private boolean isJwtValid(String jwt, String memberKey) {
        boolean returnValue = true;

        String subject = null;

        try {
            subject = Jwts.parserBuilder().setSigningKey(this.env.getProperty("jwt.secret"))
                    .build().parseClaimsJws(jwt).getBody()
                    .getSubject();

        } catch (Exception e) {
            returnValue = false;
        }

        if (subject == null || subject.isEmpty()) {
            returnValue = false;
        }

        log.debug("[토큰 유효성 검사] = {}", returnValue);
        log.debug("[멤버키] subject = {}", subject);

        if (!subject.equals(memberKey)) {
            log.debug("[멤버키] 불일치");
            returnValue = false;
        }

        return returnValue;
    }

    private String getMemberKey(ServerWebExchange exchange) {
        String uri = exchange.getRequest().getURI().toString();
        log.debug("[멤버키] uri = {}", uri);
        String[] splitUri = uri.split("/");
        log.debug("[멤버키] uri에서 뽑은 멤버키 = {}", splitUri[5]);
        return splitUri[5];
    }
}
