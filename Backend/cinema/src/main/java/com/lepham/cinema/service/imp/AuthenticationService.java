package com.lepham.cinema.service.imp;

import com.lepham.cinema.dto.request.LoginRequest;
import com.lepham.cinema.dto.response.AuthenticationResponse;
import com.lepham.cinema.entity.AccountEntity;
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jwt.JWTClaimsSet;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthenticationService {

    @NonFinal
    @Value("${jwt.signerKey}")
    protected String SIGNER_KEY;

    AccountService accountService;

    public AuthenticationResponse authenticate(LoginRequest request){
        AccountEntity account = accountService.login(request);
        if(account!=null){
            var token = generationToken(account);
            return AuthenticationResponse.builder()
                    .token(token)
                    .authenticated(true)
                    .role(account.getRole())
                    .email(account.getEmail())
                    .build();
        }
        return AuthenticationResponse.builder()
                .token("")
                .authenticated(false)
                .role("")
                .email("")
                .build();
    }

    public String generationToken(AccountEntity account){
        JWSHeader header = new JWSHeader(JWSAlgorithm.HS256);

        JWTClaimsSet jwtClaimsSet = new JWTClaimsSet.Builder()
                .subject(account.getEmail())
                .issuer("devteria.com")
                .issueTime(new Date())
                .expirationTime(new Date(Instant.now().plus(1, ChronoUnit.HOURS).toEpochMilli()))
                .claim("scope",account.getRole())
                .build();
        Payload payload = new Payload(jwtClaimsSet.toJSONObject());

        JWSObject jwsObject = new JWSObject(header, payload);

        try {
            jwsObject.sign(new MACSigner(SIGNER_KEY.getBytes()));
            return jwsObject.serialize();
        } catch (JOSEException e) {
            log.error("Cannot create token", e);
            throw new RuntimeException(e);
        }
    }
}
