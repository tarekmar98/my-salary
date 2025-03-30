package my_salary.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import java.time.OffsetDateTime;


@Getter
@Setter
@Entity
@Table(name = "auth_user")
public class AuthUser {
    @Id
    private String phoneNumber;

    private String OTP;
    private OffsetDateTime lastTry;
    private Integer numTries;
    private Integer sameOtpTries;

    public AuthUser() {}

    public AuthUser(String phoneNumber) {
        this.phoneNumber = phoneNumber;
        this.numTries = 0;
        this.lastTry = OffsetDateTime.now();
        this.sameOtpTries = 0;
    }

    public void validate() {
        if (phoneNumber.charAt(0) != '+' || phoneNumber.length() != 13) {
            throw new IllegalArgumentException("Invalid Phone Number");
        }
    }

    @Override
    public String toString() {
        return "AuthUser{" + "phoneNumber=" + phoneNumber + ", OTP=" + OTP + ", lastTry=" + lastTry + ", numTries=" + numTries + ", sameOtpTries=" + sameOtpTries + '}';
    }
}