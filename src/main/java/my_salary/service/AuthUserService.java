package my_salary.service;

import my_salary.Resources.Statics;
import my_salary.authentication.JwtTokenProvider;
import my_salary.entity.AuthUser;
import my_salary.repository.AuthUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.util.HashMap;


@Service
public class AuthUserService {
    @Autowired
    private SmsSenderService smsSenderService;

    @Autowired
    private AuthUserRepository authUserRepository;

    private final JwtTokenProvider jwtTokenProvider;

    public AuthUserService() {
        jwtTokenProvider = new JwtTokenProvider();
    }

    public ResponseEntity<?> signUp(String phoneNumber) {
        AuthUser authUser = authUserRepository.findById(phoneNumber).orElse(null);
        if (authUser == null) {
            authUser = new AuthUser(phoneNumber);
        }

        authUser.validate();
        String verificationCode = String.valueOf((int) (Math.random() * 900000 + 100000));
        authUser.setOTP(verificationCode);
        authUser.setSameOtpTries(0);
        System.out.println("VerificationCode: " + verificationCode);
        if (Duration.between(authUser.getLastTry().toInstant(), Instant.now()).toMinutes() < Statics.MIN_LOGIN_TIME_DIFF_MINUTES) {
            authUser.setNumTries(authUser.getNumTries() + 1);
        } else {
            authUser.setLastTry(OffsetDateTime.now());
            authUser.setNumTries(1);
        }

        authUserRepository.save(authUser);
        smsSenderService.sendMessage(phoneNumber, verificationCode);
        if (authUser.getNumTries() > Statics.MAX_LOGIN_ATTEMPTS) {
            throw new IllegalArgumentException("Too many login attempts!");
        }

        return ResponseEntity.ok().body("Verification code sent successfully.");
    }

    public ResponseEntity<?> verifySignUp(String phoneNumber, String verificationCode) {
        AuthUser authUser = authUserRepository.findById(phoneNumber).orElse(null);
        if (authUser == null) {
            throw new IllegalArgumentException("User does not exist!");
        }

        authUser.validate();
        if (authUser.getOTP().equals(verificationCode) && authUser.getSameOtpTries() < Statics.MAX_SAME_OTP_TRIES) {
            String newVerificationCode = String.valueOf((int) (Math.random() * 900000 + 100000));
            authUser.setOTP(newVerificationCode);
            authUser.setSameOtpTries(0);
            authUser.setNumTries(0);
            authUserRepository.save(authUser);
            String token = jwtTokenProvider.generateToken(phoneNumber);
            return ResponseEntity.ok(new HashMap<>() {{
                put("token", token);
            }});

        }

        authUser.setSameOtpTries(authUser.getSameOtpTries() + 1);
        throw new IllegalArgumentException("Verification code is incorrect!");
    }
}