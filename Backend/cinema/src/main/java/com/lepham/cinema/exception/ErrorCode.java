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
    CATEGORY_NAME_INVALID(1015,"Request has category name is empty ",HttpStatus.BAD_REQUEST),
    STRING_IS_EMPTY(1016,"String is empty",HttpStatus.BAD_REQUEST),
    DURATION_INVALID(1017,"Duration is in 90 to 150 minute",HttpStatus.BAD_REQUEST),
    UNAUTHENTICATED(1018, "Unauthenticated", HttpStatus.UNAUTHORIZED),
    INVALID_DATE(1019, "Invalid date", HttpStatus.BAD_REQUEST),
    NUMBER_NOT_NEGATIVE(1020, "Number is not negative", HttpStatus.BAD_REQUEST),
    INVALID_PRICE(1021, "Price is invalid", HttpStatus.BAD_REQUEST),
    NOT_EXISTS_EMAIL(1022, "Email does not exists", HttpStatus.BAD_REQUEST),
    CATEGORY_NAME_DUPLICATE(1023, "Category name is duplicate", HttpStatus.BAD_REQUEST),
    FILM_NAME_DUPLICATE(1024, "Film title is duplicate", HttpStatus.BAD_REQUEST),
    SEAT_WAS_ORDERED(1025, "Seat was ordered", HttpStatus.BAD_REQUEST),
    VOUCHER_NOY_ENOUGH(1026, "Voucher was not enough", HttpStatus.BAD_REQUEST),
    SEAT_NOT_ORDERED(1027, "Seat was not ordered", HttpStatus.BAD_REQUEST),
    ACCOUNT_NOT_EXIST(1028,"Account was not exist ", HttpStatus.BAD_REQUEST),
    SHOWTIME_IS_COMING_SOON(1029,"Showtime is coming soon, please choose a showtime other ", HttpStatus.BAD_REQUEST),
    ORDER_NOT_FOUND(1030,"Order not found", HttpStatus.BAD_REQUEST),
    FOOD_NOT_FOUND(1031,"Food not found",HttpStatus.BAD_REQUEST),
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
