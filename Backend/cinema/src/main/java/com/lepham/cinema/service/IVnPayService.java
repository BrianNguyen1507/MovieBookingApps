package com.lepham.cinema.service;

import com.lepham.cinema.dto.response.VnPayResponse;

public interface IVnPayService {
    VnPayResponse getPay(long total);
}
