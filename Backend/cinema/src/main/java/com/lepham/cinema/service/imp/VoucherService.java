package com.lepham.cinema.service.imp;

import com.lepham.cinema.converter.VoucherConverter;
import com.lepham.cinema.dto.request.VoucherRequest;
import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.entity.VoucherEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.VoucherRepository;
import com.lepham.cinema.service.IVoucherService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class VoucherService implements IVoucherService {

    VoucherRepository voucherRepository;

    VoucherConverter voucherConverter;

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<VoucherResponse> getAllVoucher() {
        return voucherRepository.findAllByHide(false)
                .stream()
                .map(voucherConverter::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public VoucherResponse addVoucher(VoucherRequest request) throws ParseException {
        VoucherEntity entity = voucherConverter.toEntity(request);
        entity.setHide(false);
        return voucherConverter.toResponse(voucherRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public VoucherResponse updateVoucher(long id, VoucherRequest request) throws ParseException {
        VoucherEntity entity = voucherRepository.findById(id)
                .orElseThrow(()-> new AppException(ErrorCode.NULL_EXCEPTION));
        voucherConverter.updateVoucher(entity,request);
        return voucherConverter.toResponse(voucherRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteVoucher(long id) {
        VoucherEntity entity = voucherRepository.findById(id)
                .orElseThrow(()-> new AppException(ErrorCode.NULL_EXCEPTION));
        if(entity.getAccounts()==null){
            voucherRepository.delete(entity);
        }
        else{
            entity.setHide(true);
            voucherRepository.save(entity);
        }

    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public List<VoucherResponse> getAllVoucherByAccountAndMinLimit(double price, long accountId) {
        List<VoucherResponse> responses = new ArrayList<>();
        List<VoucherEntity> vouchers = voucherRepository.findAllByAllowVoucher(price, accountId);
        if (!vouchers.isEmpty()) {
            vouchers.forEach(entity -> {
                VoucherResponse response = voucherConverter.toResponse(entity);
                response.setAllow(true);
                responses.add(response);
            });
        }
        vouchers = voucherRepository.findAllByNotAllowVoucher(price, accountId);
        if (!vouchers.isEmpty()) {
            vouchers.forEach(entity -> {
                VoucherResponse response = voucherConverter.toResponse(entity);
                response.setAllow(false);
                responses.add(response);
            });
        }

        return responses;
    }
}
