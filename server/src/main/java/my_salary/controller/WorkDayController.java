package my_salary.controller;
import my_salary.entity.User;
import my_salary.entity.WorkDay;
import my_salary.service.UserService;
import my_salary.service.WorkDayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.YearMonth;

@CrossOrigin(origins = "*")
@RestController
public class WorkDayController {
    @Autowired
    WorkDayService workDayService;

    @PutMapping("/startWorkDay/{jobId}/{workType}")
    public ResponseEntity<?> startWorkDay(@PathVariable("jobId") Long jobId,
                                          @PathVariable("workType") String workType,
                                          @PathVariable("timeDiffUtc") Float timeDiffUtc,
                                          @RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.ok().body(workDayService.startWorkDay(jobId, workType, phoneNumber, timeDiffUtc));
    }

    @GetMapping("/myWorkDays/{jobId}/{salaryMonth}/{salaryYear}")
    public ResponseEntity<?> myWorkDays(@PathVariable("jobId") Long jobId, @PathVariable("salaryMonth") int salaryMonth,
                                        @PathVariable("salaryYear") int salaryYear, @RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.ok().body(workDayService.myWorkDays(jobId, salaryMonth, salaryYear, phoneNumber));
    }

    @PutMapping("/addWorkDay")
    public ResponseEntity<?> addWorkDay(@RequestBody WorkDay workDay, @RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.status(201).body(workDayService.addWorkDay(workDay, phoneNumber));
    }

    @DeleteMapping("/deleteWorkDay/{workDayId}")
    public ResponseEntity<?> deleteWorkDay(@PathVariable("workDayId") Long workDayId) {
        workDayService.deleteWorkDay(workDayId);
        return ResponseEntity.ok().build();
    }
}
