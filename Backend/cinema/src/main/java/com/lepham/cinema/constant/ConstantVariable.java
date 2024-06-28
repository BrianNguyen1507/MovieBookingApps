package com.lepham.cinema.constant;

import java.time.format.DateTimeFormatter;

public class ConstantVariable {
    public static final int totalMinuteByDay = 60*16;
    public static final int step = 7;
    public static final int hourStart =8;
    public static final int dayOfSchedule = 10;
    public static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
}
