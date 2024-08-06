package com.lepham.cinema.service;

public interface ISeatHeldService {
    void holeSeat(long id,String seat);
    boolean checkAccountHoldSeat(long id, String seat);
    void returnSeat(long id,String seat);
    void autoReturnSeat();
}
