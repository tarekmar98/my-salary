package my_salary.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@Entity
@Table(name = "app_user")
public class User {
    @Id
    @Column(name = "phone_number")
    private String phoneNumber;

    private String country;
    private String city;
    private String religion;
    private String language;


    public User() {}

    public User(String phoneNumber, String country, String city, String religion, String language) {
        try {
            this.phoneNumber = phoneNumber;
            this.country = country;
            this.city = city;
            this.religion = religion;
            this.language = language;

        } catch (IllegalArgumentException e) {
            System.out.println(e.getMessage());
        }
    }

    @Override
    public String toString() {
        return "User{" + "phoneNumber=" + phoneNumber + ", country=" + country + ", city=" + city + ", religion=" + religion + ", language=" + language + '}';
    }
}