package my_salary.authentication;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

import java.util.Date;

public class JwtTokenProvider {
    private static final String SECRET_KEY = "ed7ALLPiFlrE7q0M38CB433I3mnjPzKOhoL55XlMhqI=";

    public String generateToken(String phoneNumber) {
        long expirationMillis = 1000 * 60 * 60 * 24 * 365 * 10;

        return Jwts.builder()
                .setSubject(phoneNumber)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationMillis))
                .signWith(SignatureAlgorithm.HS256, SECRET_KEY)
                .compact();
    }
}