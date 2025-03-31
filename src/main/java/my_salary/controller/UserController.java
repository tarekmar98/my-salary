package my_salary.controller;
import my_salary.entity.User;
import my_salary.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;



@RestController
public class UserController {
    @Autowired
    UserService userService;

    @GetMapping("/myProfile")
    public ResponseEntity<?> getMyProfile(@RequestHeader("phoneNumber") String phoneNumber) {
        return this.userService.getProfileByPhoneNumber(phoneNumber);
    }

    @PutMapping("/addProfile")
    public ResponseEntity<?> addProfile(@RequestBody User user, @RequestHeader("phoneNumber") String phoneNumber) {
        return this.userService.updateUser(phoneNumber, user, true);
    }

    @PutMapping("updateProfile")
    public ResponseEntity<?> updateProfile(@RequestBody User user, @RequestHeader("phoneNumber") String phoneNumber) {
        return this.userService.updateUser(phoneNumber, user, false);
    }
}
