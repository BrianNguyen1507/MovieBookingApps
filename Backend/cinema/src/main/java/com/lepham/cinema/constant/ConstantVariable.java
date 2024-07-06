package com.lepham.cinema.constant;

import java.time.format.DateTimeFormatter;

public class ConstantVariable {
    public static final int totalMinuteByDay = 60*16;
    public static final int step = 7;
    public static final int hourStart =8;
    public static final int dayOfSchedule = 10;
    public static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
    public static final int direct = 0;
    public static final int percent = 1;
    public static final int FILM_RELEASE = 0;
    public static final int FILM_FUTURE = 1;
    public static final int FILM_STOP_RELEASE = 2;
    public static final int ORDER_UNUSED = 0;
    public static final int ORDER_USED = 1;
    public static final int ORDER_EXPIRED_USED = 2;

    public static final int SEAT_EMPTY = 0;
    public static final int SEAT_ORDER = 1;
    public static final int SEAT_HOLD = 2;
}
