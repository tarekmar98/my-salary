package my_salary.controller;

import my_salary.service.SalaryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SalaryController {
    @Autowired
    SalaryService salaryService;

    @GetMapping("/salaryInfo/{jobId}/{month}/{year}")
    public ResponseEntity<?> getSalaryInfo(@PathVariable("jobId") Long jobId, @PathVariable("month") Integer month,
                                           @PathVariable("year") Integer year, @RequestHeader("phoneNumber") String phoneNumber) {
        return ResponseEntity.ok().body(salaryService.calcSalaryInfo(jobId, month, year, phoneNumber));
    }
}
