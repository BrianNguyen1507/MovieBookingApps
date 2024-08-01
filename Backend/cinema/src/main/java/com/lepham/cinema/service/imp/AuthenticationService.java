package com.lepham.cinema.service.imp;

import com.lepham.cinema.dto.request.LoginRequest;
import com.lepham.cinema.dto.request.LogoutRequest;
import com.lepham.cinema.dto.request.RefreshTokenRequest;
import com.lepham.cinema.dto.response.AuthenticationResponse;
import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.InvalidatedToken;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.AccountRepository;
import com.lepham.cinema.repository.InValidatedTokenRepository;
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthenticationService {

    @NonFinal
    @Value("${jwt.signerKey}")
    protected String SIGNER_KEY;

    @NonFinal
    @Value("${jwt.valid-duration}")
    protected long VALID_DURATION;

    AccountService accountService;

    InValidatedTokenRepository inValidatedTokenRepository;

    AccountRepository accountRepository;
    public boolean introspect(String token) throws JOSEException, ParseException {
        boolean isValid = true;
        try {
            verifyToken(token, false);
        } catch (AppException e) {
            isValid = false;
        }
        return isValid;
    }
    public AuthenticationResponse authenticate(LoginRequest request){
        AccountEntity account = accountService.login(request);
        if(account!=null){
            var token = generationToken(account);
            return AuthenticationResponse.builder()
                    .token(token)
                    .authenticated(true)
                    .name(account.getFullName())
                    .role(account.getRole())
                    .email(account.getEmail())
                    .avatar(account.getAvatar())
                    .build();
        }
        return AuthenticationResponse.builder()
                .token("")
                .authenticated(false)
                .name("")
                .role("")
                .email("")
                .build();
    }

    private String generationToken(AccountEntity account){
        JWSHeader header = new JWSHeader(JWSAlgorithm.HS512);

        JWTClaimsSet jwtClaimsSet = new JWTClaimsSet.Builder()
                .subject(account.getEmail())
                .issuer("devteria.com")
                .issueTime(new Date())
                .expirationTime(new Date(Instant.now().plus(VALID_DURATION, ChronoUnit.SECONDS).toEpochMilli()))
                .claim("scope",account.getRole())
                .jwtID(UUID.randomUUID().toString())
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

    public void logout(LogoutRequest request) throws ParseException, JOSEException {
        try{
            var signToken = verifyToken(request.getToken(),true);
            String jit = signToken.getJWTClaimsSet().getJWTID();
            Date expiredTime = signToken.getJWTClaimsSet().getExpirationTime();
            InvalidatedToken invalidatedToken = InvalidatedToken
                            .builder()
                            .id(jit)
                            .expired(expiredTime)
                            .build();
            inValidatedTokenRepository.save(invalidatedToken);
        }catch (AppException exception){
            log.info("Token already expired");
        }
    }

    public AuthenticationResponse refreshToken(RefreshTokenRequest request) throws ParseException, JOSEException {

        try {
            var singJWT = verifyToken(request.getToken(), true);

            String jit = singJWT.getJWTClaimsSet().getJWTID();
            Date expiredTime = singJWT.getJWTClaimsSet().getExpirationTime();

            AccountEntity account = accountRepository.findByEmail(singJWT.getJWTClaimsSet().getSubject())
                    .orElseThrow(()->new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
            if (account == null) throw new AppException(ErrorCode.NULL_EXCEPTION);

            InvalidatedToken invalidatedToken = InvalidatedToken.builder().id(jit).expired(expiredTime).build();

            inValidatedTokenRepository.save(invalidatedToken);
            var token = generationToken(account);
            return AuthenticationResponse.builder()
                    .authenticated(true)
                    .email(account.getEmail())
                    .name(account.getFullName())
                    .role(account.getRole())
                    .token(token)
                    .build();

        } catch (AppException exception) {
            log.info("Token already expired");
        }
        return  null;
    }
    private SignedJWT verifyToken(String token, boolean isRefresh) throws JOSEException, ParseException {
        JWSVerifier verifier = new MACVerifier(SIGNER_KEY.getBytes());

        SignedJWT signedJWT = SignedJWT.parse(token);

        Date expiryTime = (isRefresh)
                ? new Date(signedJWT.getJWTClaimsSet().getIssueTime()
                .toInstant().plus(VALID_DURATION, ChronoUnit.SECONDS).toEpochMilli())
                : signedJWT.getJWTClaimsSet().getExpirationTime();

        var verified = signedJWT.verify(verifier);


        if (!(verified && expiryTime.after(new Date()))) throw new AppException(ErrorCode.UNAUTHENTICATED);

        if (inValidatedTokenRepository.existsById(signedJWT.getJWTClaimsSet().getJWTID()))
            throw new AppException(ErrorCode.UNAUTHENTICATED);

        return signedJWT;
    }

}
