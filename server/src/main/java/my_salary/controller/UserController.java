package my_salary.controller;
import my_salary.entity.User;
import my_salary.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@CrossOrigin(origins = "*")
@RestController
public class UserController {
    @Autowired
    UserService userService;

    @GetMapping("/myProfile")
    public ResponseEntity<?> getMyProfile(@RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.ok().body(this.userService.getProfileByPhoneNumber(phoneNumber));
    }

    @PutMapping("/addProfile")
    public ResponseEntity<?> addProfile(@RequestBody User user, @RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.status(201).body(this.userService.updateUser(phoneNumber, user, true));
    }

    @PutMapping("updateProfile")
    public ResponseEntity<?> updateProfile(@RequestBody User user, @RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.ok().body(this.userService.updateUser(phoneNumber, user, false));
    }
}
