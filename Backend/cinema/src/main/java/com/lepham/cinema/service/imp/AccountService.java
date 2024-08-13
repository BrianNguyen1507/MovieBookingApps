package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.converter.AccountConverter;
import com.lepham.cinema.dto.request.*;
import com.lepham.cinema.dto.response.AccountResponse;
import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.AccountRepository;
import com.lepham.cinema.service.IAccountService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.security.SecureRandom;
import java.text.ParseException;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AccountService implements IAccountService {


    private static final String EMAIL_PATTERN =
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@" +
                    "(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    private static final String PHONE_NUMBER_PATTERN =
            "^\\+?[0-9. ()-]{7,25}$";

    private static final int ACTIVATED = 1;
    private static final Pattern emailPattern = Pattern.compile(EMAIL_PATTERN);
    private static final Pattern phonePattern = Pattern.compile(PHONE_NUMBER_PATTERN);
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private static final int OTP_LENGTH =6;

    AccountRepository accountRepository;

    AccountConverter accountConverter;

    PasswordEncoder passwordEncoder;

    JavaMailSender mailSender;

    @Override
    public AccountResponse createAccount(AccountRequest request) throws MessagingException, UnsupportedEncodingException {
        if(!checkEmailValid(request.getEmail())) throw new AppException(ErrorCode.INVALID_EMAIL);
        if(checkEmailExists(request.getEmail())) throw new AppException(ErrorCode.EXISTS_EMAIL);

        if(!checkPasswordValid(request.getPassword())) throw new AppException(ErrorCode.PASSWORD_INVALID);
        if(!checkPhoneValid(request.getPhoneNumber())) throw new AppException(ErrorCode.INVALID_PHONE);

        AccountEntity entity = accountConverter.toEntity(request);

        if (accountRepository.findByEmail(request.getEmail()).isPresent()){
            long id= accountRepository.findByEmail(request.getEmail()).get().getId();
            entity.setId(id);
        }
        entity.setPassword(passwordEncoder.encode(request.getPassword()));
        String OTP = generateOTP();
        entity.setOtp(OTP);
        entity.setOtpRequestTime(LocalDateTime.now());
        entity = accountRepository.save(entity);
        sendOTPEmail(entity);
        return accountConverter.toResponse(entity);
    }

    @Override
    public AccountResponse checkOTP(OTPRequest request) {
        AccountEntity entity = accountRepository.findByEmail(request.getEmail())
                .orElseThrow(()->new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        LocalDateTime currentDateTime = LocalDateTime.now();
        LocalDateTime expiredDateTime = entity.getOtpRequestTime().plusMinutes(5);
        if(entity.getOtp().equals(request.getOtp()) ){
            if(currentDateTime.isBefore(expiredDateTime)){
                entity.setActive(1);
                if(!request.getMethod().equals(ConstantVariable.FORGOT_PASSWORD)){
                    entity.setOtp(null);
                    entity.setOtpRequestTime(null);
                }
                accountRepository.save(entity);
            }
            else{
                entity.setOtp(null);
                entity.setOtpRequestTime(null);
                accountRepository.save(entity);
                throw new AppException(ErrorCode.EXPIRED_TIME_OTP);
            }
        }
        else throw new AppException(ErrorCode.INCORRECT_OTP);
        return accountConverter.toResponse(entity);
    }

    @Override
    public AccountEntity login(LoginRequest request) {
        AccountEntity entity = accountRepository.findByEmail(request.getEmail())
                .orElseThrow(()->new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        if(entity==null) throw new AppException(ErrorCode.EMAIL_PASSWORD_INCORRECT);
        if(passwordEncoder.matches(request.getPassword(),entity.getPassword())
                && entity.getActive() ==ACTIVATED) return entity;
        else throw new AppException(ErrorCode.EMAIL_PASSWORD_INCORRECT);
    }

    @Override
    public AccountResponse forgotPassWord(String email) throws MessagingException, UnsupportedEncodingException {
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(()->new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        if(account == null || account.getActive() != ACTIVATED) throw new AppException(ErrorCode.NOT_EXISTS_EMAIL);
        String OTP = generateOTP();
        account.setOtp(OTP);
        account.setOtpRequestTime(LocalDateTime.now());
        sendOTPEmail(account);
        accountRepository.save(account);
        return accountConverter.toResponse(accountRepository.save(account));
    }

    @Override
    public AccountResponse resetPassword(ResetPasswordRequest request) {
        if(!checkPasswordValid(request.getPassword())) throw new AppException(ErrorCode.PASSWORD_INVALID);
        AccountEntity account = accountRepository.findByEmail(request.getEmail())
                .orElseThrow(()->new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        if(account==null) throw new AppException(ErrorCode.NOT_EXISTS_EMAIL);
        if(!Objects.equals(account.getOtp(),request.getOtp())) throw new AppException(ErrorCode.INCORRECT_OTP);
        String password = passwordEncoder.encode(request.getPassword());
        account.setPassword(password);
        account.setOtp(null);
        account.setOtpRequestTime(null);
        accountRepository.save(account);
        return accountConverter.toResponse(account);
    }

    @Override
    @PostAuthorize("returnObject.email == authentication.name")
    public AccountResponse getMyInfo() {
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(()->new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        return accountConverter.toResponse(account);
    }

    @Override
    @PostAuthorize("returnObject.email == authentication.name")
    public AccountResponse updateAccount(AccountRequest accountRequest){
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        if(!checkPhoneValid(accountRequest.getPhoneNumber())) throw new AppException(ErrorCode.INVALID_PHONE);
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(()->new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        accountConverter.updateAccount(account,accountRequest);
        return accountConverter.toResponse(accountRepository.save(account));
    }

    @Override
    @PostAuthorize("returnObject.email == authentication.name")
    public AccountResponse updatePassword(UpdatePwdRequest request) {
        if(!checkPasswordValid(request.getPassword())) throw new AppException(ErrorCode.PASSWORD_INVALID);
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(()->new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        if(!passwordEncoder.matches(request.getPassword(),account.getPassword())) throw new AppException(ErrorCode.PASSWORD_INVALID);
        if(Objects.equals(request.getPassword(),request.getNewPassword())) throw new AppException(ErrorCode.DUPLICATE_PASSWORD);
        account.setPassword(passwordEncoder.encode(request.getNewPassword()));
        return accountConverter.toResponse(accountRepository.save(account));
    }


    boolean checkEmailExists(String email){
        return accountRepository.existsByEmailAndActive(email, 1);
    }
    boolean checkEmailValid(String email){
        if (email == null) {
            return false;
        }
        Matcher matcher = emailPattern.matcher(email);
        return matcher.matches();
    }
    boolean checkPhoneValid(String phoneNumber){
        if (phoneNumber == null) {
            return false;
        }
        Matcher matcher = phonePattern.matcher(phoneNumber);
        return matcher.matches();
    }

    boolean checkPasswordValid(String password){
        if (password.length() < 8) {
            return false;
        }
        if (password.contains(" ")) {
            return false;
        }

        if (!Pattern.compile("[A-Z]").matcher(password).find()) {
            return false;
        }

        if (!Pattern.compile("[a-z]").matcher(password).find()) {
            return false;
        }

        if (!Pattern.compile("[0-9]").matcher(password).find()) {
            return false;
        }
        return Pattern.compile("[!@#$%^&*(),.?\":{}|<>]").matcher(password).find();
    }

    String generateOTP(){
        // Create a StringBuilder to hold the random number
        StringBuilder sb = new StringBuilder(AccountService.OTP_LENGTH);

        // Generate each digit and append to the StringBuilder
        for (int i = 0; i < AccountService.OTP_LENGTH; i++) {
            int randomDigit = SECURE_RANDOM.nextInt(10); // Generates a random digit between 0 and 9
            sb.append(randomDigit);
        }
        return sb.toString();
    }
    public void sendOTPEmail(AccountEntity entity)
            throws UnsupportedEncodingException, MessagingException {

        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message);

        helper.setFrom("contact@cinema.com", "STUCinema");
        helper.setTo(entity.getEmail());

        String subject = "Here's your One Time Password (OTP) - Expire in 5 minutes!";

        String content = "<p>Hello " + entity.getFullName() + "</p>"
                + "<p>For security reason, you're required to use the following "
                + "One Time Password to login:</p>"
                + "<p><b>" + entity.getOtp()+ "</b></p>"
                + "<br>"
                + "<p>Note: this OTP is set to expire in 5 minutes.</p>";

        helper.setSubject(subject);

        helper.setText(content, true);

        mailSender.send(message);
    }

}
