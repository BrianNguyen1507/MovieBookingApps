package com.lepham.cinema.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

import java.net.http.HttpRequest;

@Getter
public enum ErrorCode {
    NULL_EXCEPTION(8888, "Object Null", HttpStatus.BAD_REQUEST),
    UNCATEGORIZED_EXCEPTION(9999, "Uncategorized error", HttpStatus.INTERNAL_SERVER_ERROR),
    INVALID_kEY(1001,"Uncategorized error", HttpStatus.BAD_REQUEST),
    UNAUTHORIZED(1002, "You do not have permission", HttpStatus.FORBIDDEN),
    INVALID_EMAIL(1003,"Email invalid",HttpStatus.BAD_REQUEST),
    EXISTS_EMAIL(1004,"Email already exists", HttpStatus.BAD_REQUEST),
    INVALID_PHONE(1005,"Phone Number invalid",HttpStatus.BAD_REQUEST),
    INVALID_DOB(1006,"Day of birth invalid",HttpStatus.BAD_REQUEST),
    ACCOUNT_INACTIVE(1007,"Account inactive ", HttpStatus.BAD_REQUEST),
    EXPIRED_TIME_OTP(1008,"Expired time OTP", HttpStatus.BAD_REQUEST),
    EMAIL_PASSWORD_INCORRECT(1009,"Email or password incorrect", HttpStatus.BAD_REQUEST),
    INCORRECT_OTP(1010,"OTP incorrect",HttpStatus.BAD_REQUEST),
    PASSWORD_INVALID(1011,"Password invalid",HttpStatus.BAD_REQUEST),
    CATEGORY_NOT_FOUND(1012,"Category not found",HttpStatus.BAD_REQUEST),
    FILM_NOT_FOUND(1013,"Film not found",HttpStatus.BAD_REQUEST),
    ROOM_EXISTS(1014,"Room was existed in movie theater",HttpStatus.BAD_REQUEST),
    ;


    ErrorCode(int code, String message, HttpStatusCode statusCode) {
        this.code = code;
        this.message = message;
        this.statusCode = statusCode;
    }

    private int code;
    private  String message;
    private HttpStatusCode statusCode;

}
