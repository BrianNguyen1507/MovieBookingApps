package com.lepham.cinema.converter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public abstract class DateConverter {
    private static final SimpleDateFormat sdfYMD = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat sdfDMY = new SimpleDateFormat("dd-MM-yyyy");
    private static final SimpleDateFormat sdfYMDTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static final SimpleDateFormat sdfDMYTime = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

    private static final SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm:ss");

    public static Date stringParseYMD(String date) throws ParseException {
        return sdfYMD.parse(sdfYMD.format(sdfDMY.parse(date)));
    }
    public static String toStringDMY(Date date){
        return sdfDMY.format(date);
    }
    public static   String DMYtoStringYMD(String date) throws ParseException {
        return sdfYMD.format(sdfDMY.parse(date));
    }

    public static Date toYMDTime(String date) throws ParseException {
        return sdfYMDTime.parse(sdfYMDTime.format(sdfDMYTime.parse(date)));
    }

    public static String toStringYMDTime(Date date){
        return  sdfYMDTime.format(date);
    }
    public static String toStringDMYTime(Date dateYMD){
        return sdfDMYTime.format(dateYMD);
    }

    public static String toTime(Date date){
        return sdfTime.format(date);
    }
}
