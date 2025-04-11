package my_salary.controller;


import my_salary.entity.JobInfo;
import my_salary.service.JobInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*")
@RestController
public class JobInfoController {
    @Autowired
    JobInfoService jobInfoService;

    @GetMapping("/myJobs")
    public ResponseEntity<?> myJobs(@RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.ok().body(jobInfoService.myJobs(phoneNumber));
    }

    @PutMapping("/addJob")
    public ResponseEntity<?> addJob(@RequestBody JobInfo jobInfo, @RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.status(201).body(jobInfoService.addJob(jobInfo, phoneNumber));
    }

    @PutMapping("/updateJob")
    public ResponseEntity<?> updateJob(@RequestBody JobInfo jobInfo, @RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.ok().body(jobInfoService.updateJob(jobInfo, phoneNumber));
    }

    @DeleteMapping("/deleteJob/{id}")
    public ResponseEntity<?> deleteJob(@PathVariable Long id) {
        jobInfoService.deleteJob(id);
        return ResponseEntity.ok().build();
    }
}
