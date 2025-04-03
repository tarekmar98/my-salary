package my_salary.controller;
import my_salary.service.AuthUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.NoSuchAlgorithmException;


@RestController
public class AuthUserController {
    @Autowired
    AuthUserService authUserService;


    @PutMapping("/signUp/{phoneNumber}")
    public ResponseEntity<?> signUp(@PathVariable String phoneNumber) {
        authUserService.signUp(phoneNumber);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/verifySignUp/{phoneNumber}/{verificationCode}")
    public ResponseEntity<?> verifySignUp(@PathVariable String phoneNumber, @PathVariable String verificationCode) {
        return ResponseEntity.ok().body(authUserService.verifySignUp(phoneNumber, verificationCode));
    }

}