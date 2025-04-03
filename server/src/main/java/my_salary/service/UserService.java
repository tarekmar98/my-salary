package my_salary.service;

import my_salary.entity.User;
import my_salary.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Objects;


@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ResourcesService resourcesService;

    public User getProfileByPhoneNumber(String phoneNumber) {
        User user = this.userRepository.findById(phoneNumber).orElseThrow(() -> new IllegalArgumentException("User does not exist!"));
        return user;
    }

    public User updateUser(String phoneNumber, User user, boolean newUser) {
        if (!Objects.equals(phoneNumber, user.getPhoneNumber())) {
            throw new IllegalArgumentException("Invalid phone number!");
        }

        if (!newUser && !this.userRepository.existsById(phoneNumber)) {
            throw new IllegalArgumentException("User does not exist!");
        }

        if (newUser && this.userRepository.existsById(phoneNumber)) {
            throw new IllegalArgumentException("User already exists!");
        }

        validate(user);
        this.userRepository.save(user);
        return user;
    }

    public void validate(User user) {
        if (user.getPhoneNumber() == null || user.getPhoneNumber().charAt(0) != '+' || user.getPhoneNumber().length() != 13) {
            throw new IllegalArgumentException("Invalid Phone Number");
        }

        if (!resourcesService.isValidReligion(user.getReligion())) {
            throw new IllegalArgumentException("Invalid Religion");
        }

        if (!resourcesService.isValidLanguage(user.getLanguage())) {
            throw new IllegalArgumentException("Invalid Language");
        }

        if (!resourcesService.isValidCountry(user.getCountry())) {
            throw new IllegalArgumentException("Invalid Country");
        }

        if (!resourcesService.isValidCity(user.getCountry(), user.getCity())) {
            throw new IllegalArgumentException("Invalid City");
        }
    }
}
