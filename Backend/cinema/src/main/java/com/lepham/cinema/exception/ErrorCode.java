package com.lepham.cinema.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

import java.net.http.HttpRequest;

@Getter
public enum ErrorCode {
    INVALID_JSON_FORMAT(8888, "Invalid Json format", HttpStatus.BAD_REQUEST),
    UNCATEGORIZED_EXCEPTION(9999, "Uncategorized error", HttpStatus.INTERNAL_SERVER_ERROR),
    INVALID_KEY(1001,"Invalid key", HttpStatus.BAD_REQUEST),
    UNAUTHORIZED(1002, "You do not have permission", HttpStatus.FORBIDDEN),
    INVALID_EMAIL(1003,"Email invalid",HttpStatus.BAD_REQUEST),
    EXISTS_EMAIL(1004,"Email already exists", HttpStatus.BAD_REQUEST),
    INVALID_PHONE(1005,"Phone Number invalid",HttpStatus.BAD_REQUEST),
    INVALID_DOB(1006,"Day of birth invalid",HttpStatus.BAD_REQUEST),
    ACCOUNT_INACTIVE(1007,"Account inactive ", HttpStatus.BAD_REQUEST),
    EXPIRED_TIME_OTP(1008,"Expired time OTP", HttpStatus.BAD_REQUEST),
    EMAIL_PASSWORD_INCORRECT(1009,"Email or password incorrect", HttpStatus.BAD_REQUEST),
    INCORRECT_OTP(1010,"OTP incorrect",HttpStatus.BAD_REQUEST),
    PASSWORD_INVALID(1011,"Password must have at least 8 characters, one capital letter and one special character",HttpStatus.BAD_REQUEST),
    CATEGORY_NOT_FOUND(1012,"Category not found",HttpStatus.BAD_REQUEST),
    FILM_NOT_FOUND(1013,"Film not found",HttpStatus.BAD_REQUEST),
    ROOM_EXISTS(1014,"Room was existed in movie theater",HttpStatus.BAD_REQUEST),
    CATEGORY_NAME_INVALID(1015,"Request has category name is empty ",HttpStatus.BAD_REQUEST),
    STRING_IS_EMPTY(1016,"Information has not been completely filled in",HttpStatus.BAD_REQUEST),
    DURATION_INVALID(1017,"Duration is in 90 to 150 minute",HttpStatus.BAD_REQUEST),
    UNAUTHENTICATED(1018, "Unauthenticated", HttpStatus.UNAUTHORIZED),
    INVALID_DATE(1019, "Invalid date", HttpStatus.BAD_REQUEST),
    NUMBER_NOT_NEGATIVE(1020, "Number is not negative", HttpStatus.BAD_REQUEST),
    INVALID_PRICE(1021, "Price is invalid", HttpStatus.BAD_REQUEST),
    NOT_EXISTS_EMAIL(1022, "Email does not exists", HttpStatus.BAD_REQUEST),
    CATEGORY_NAME_DUPLICATE(1023, "Category name is duplicate", HttpStatus.BAD_REQUEST),
    FILM_NAME_DUPLICATE(1024, "Film title is duplicate", HttpStatus.BAD_REQUEST),
    SEAT_WAS_ORDERED(1025, "Seat was ordered", HttpStatus.BAD_REQUEST),
    VOUCHER_NOT_ENOUGH(1026, "Voucher was not enough", HttpStatus.BAD_REQUEST),
    SEAT_NOT_ORDERED(1027, "Seat was ordered", HttpStatus.OK),
    ACCOUNT_NOT_EXIST(1028,"Account was not exist ", HttpStatus.BAD_REQUEST),
    SHOWTIME_IS_COMING_SOON(1029,"Showtime is coming soon, please choose a showtime other ", HttpStatus.BAD_REQUEST),
    ORDER_NOT_FOUND(1030,"Order not found", HttpStatus.BAD_REQUEST),
    FOOD_NOT_FOUND(1031,"Food not found",HttpStatus.BAD_REQUEST),
    ORDER_NOT_BELONG_ACCOUNT(1032,"The order does not belong to the account", HttpStatus.BAD_REQUEST),
    CAN_NOT_RATING(1032,"You can not rating and feedback", HttpStatus.BAD_REQUEST),
    WAS_RATING(1033,"You was rating and feedback", HttpStatus.BAD_REQUEST),
    COMPLETE_INFORMATION(1034,"Please enter complete information", HttpStatus.BAD_REQUEST),
    DUPLICATE_PASSWORD(1035,"New password must difference old password", HttpStatus.BAD_REQUEST),
    START_TIME_NOT_TODAY(1036,"Start time is not today", HttpStatus.BAD_REQUEST),
    ROOM_NOT_FOUND(1037,"Room not found",HttpStatus.BAD_REQUEST),
    SCHEDULE_NOT_FOUND(1038,"Movie schedule not found",HttpStatus.BAD_REQUEST),
    FILM_NOT_RELEASE(1039,"The movie has not been released yet",HttpStatus.BAD_REQUEST),
    DATE_AFTER_NOW(1040,"Date's schedule must after now 7 days",HttpStatus.BAD_REQUEST),
    ORDER_CAN_NOT_USED(1041,"Order was used or expired",HttpStatus.BAD_REQUEST),
    HOLD_SEAT_ABOVE_LIMIT(1042,"You can only book a maximum of 10 seats",HttpStatus.BAD_REQUEST),
    VOUCHER_NOT_FOUND(1043,"Voucher not found",HttpStatus.BAD_REQUEST),
    STRING_SEAT_INCORRECT(1044,"String seat format is incorrect",HttpStatus.BAD_REQUEST),
    THEATER_NOT_FOUND(1045,"Theater not found",HttpStatus.BAD_REQUEST),
    THEATER_NAME_EXIST(1046,"Theater name is exist",HttpStatus.BAD_REQUEST),
    NOT_TIME_TO_USE(1047,"It's not time to use it yet",HttpStatus.BAD_REQUEST),
    INVALID_FOOD_QUANTITY(1048,"Invalid food quantity",HttpStatus.BAD_REQUEST),
    INCORRECT_PAYMENT_HASH(1049,"Invalid payment hash",HttpStatus.BAD_REQUEST)
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
