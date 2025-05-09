package my_salary.service;

import my_salary.authentication.JwtTokenProvider;
import my_salary.entity.AuthUser;
import my_salary.repository.AuthUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.HashMap;


@Service
public class AuthUserService {
    @Autowired
    private SmsSenderService smsSenderService;

    @Autowired
    private AuthUserRepository authUserRepository;

    @Autowired
    private ResourcesService resourcesService;

    private final JwtTokenProvider jwtTokenProvider;

    public AuthUserService() {
        jwtTokenProvider = new JwtTokenProvider();
    }

    public void signUp(String phoneNumber) {
        AuthUser authUser = authUserRepository.findById(phoneNumber).orElse(null);
        if (authUser == null) {
            authUser = new AuthUser(phoneNumber);
        }

        validate(authUser);
        String verificationCode = String.valueOf((int) (Math.random() * 900000 + 100000));
        authUser.setOTP(verificationCode);
        authUser.setSameOtpTries(0);
        System.out.println("VerificationCode: " + verificationCode);
        if (Duration.between(authUser.getLastTry().toInstant(), Instant.now()).toMinutes() < resourcesService.statics.get("MinLoginTimeDiffMin")) {
            authUser.setNumTries(authUser.getNumTries() + 1);
        } else {
            authUser.setLastTry(OffsetDateTime.now(ZoneOffset.UTC));
            authUser.setNumTries(1);
        }

        authUserRepository.save(authUser);
        smsSenderService.sendMessage(phoneNumber, verificationCode);
        if (authUser.getNumTries() > resourcesService.statics.get("maxLoginAttempts")) {
            throw new IllegalArgumentException("Too many login attempts!");
        }
    }

    public HashMap<String, String> verifySignUp(String phoneNumber, String verificationCode) {
        AuthUser authUser = authUserRepository.findById(phoneNumber).orElse(null);
        if (authUser == null) {
            throw new IllegalArgumentException("User does not exist!");
        }

        validate(authUser);
        if (authUser.getOTP().equals(verificationCode) && authUser.getSameOtpTries() < resourcesService.statics.get("maxSameOtpTries")) {
            String newVerificationCode = String.valueOf((int) (Math.random() * 900000 + 100000));
            authUser.setOTP(newVerificationCode);
            authUser.setSameOtpTries(0);
            authUser.setNumTries(0);
            authUserRepository.save(authUser);
            String token = jwtTokenProvider.generateToken(phoneNumber);
            return new HashMap<>() {{
                put("token", token);
            }};

        }

        authUser.setSameOtpTries(authUser.getSameOtpTries() + 1);
        throw new IllegalArgumentException("Verification code is incorrect!");
    }

    public void validate(AuthUser authUser) {
        if (authUser.getPhoneNumber().charAt(0) != '+' || authUser.getPhoneNumber().length() != 13) {
            throw new IllegalArgumentException("Invalid Phone Number");
        }
    }
}