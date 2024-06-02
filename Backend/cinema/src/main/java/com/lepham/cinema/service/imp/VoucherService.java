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
        return voucherRepository.findAll()
                .stream()
                .map(voucherConverter::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public VoucherResponse addVoucher(VoucherRequest request) throws ParseException {
        VoucherEntity entity = voucherConverter.toEntity(request);
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
        voucherRepository.delete(entity);
    }
}
