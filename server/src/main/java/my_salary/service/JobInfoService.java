package my_salary.service;

import my_salary.classes.OverTimeInfo;
import my_salary.classes.ShiftsInfo;
import my_salary.classes.WeekEndInfo;
import my_salary.entity.JobInfo;
import my_salary.repository.JobInfoRepository;
import my_salary.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;


@Service
public class JobInfoService {
    @Autowired
    JobInfoRepository jobInfoRepository;

    @Autowired
    UserRepository userRepository;

    public List<JobInfo> myJobs(String phoneNumber) {
        return jobInfoRepository.findByPhoneNumber(phoneNumber);
    }

    public JobInfo addJob(JobInfo jobInfo, String phoneNumber) {
        validate(jobInfo, phoneNumber);
        jobInfoRepository.save(jobInfo);
        return jobInfo;
    }

    public JobInfo updateJob(JobInfo jobInfo, String phoneNumber) {
        if (jobInfo.getId() == null) {
            throw new IllegalArgumentException("Invalid job id!");
        }

        JobInfo oldJobInfo = jobInfoRepository.findById(jobInfo.getId()).orElseThrow(() -> new IllegalArgumentException("Job does not exist!"));
        if (!oldJobInfo.getUserPhoneNumber().equals(phoneNumber)) {
            throw new IllegalArgumentException("Invalid user!");
        }

        validate(jobInfo, phoneNumber);
        jobInfoRepository.save(jobInfo);
        return jobInfo;
    }

    public void deleteJob(Long id) {
        JobInfo jobInfo = jobInfoRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Job does not exist!"));
        jobInfoRepository.delete(jobInfo);
    }

    public JobInfo getJobById(Long id) {
        return jobInfoRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Job does not exist!"));
    }

    public void validate(JobInfo jobInfo, String phoneNumber) {
        if (!jobInfo.getUserPhoneNumber().equals(phoneNumber)) {
            throw new IllegalArgumentException("Invalid user!");
        }

        if (jobInfo.getEmployerName() == null || jobInfo.getEmployerName().isBlank()) {
            throw new IllegalArgumentException("Invalid employer name!");
        }

        if (jobInfo.getStartDate() == null || jobInfo.getStartDate().isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Invalid start date!");
        }

        if (jobInfo.getSalaryPerDay() == null || jobInfo.getSalaryPerDay() < 0
                || jobInfo.getSalaryPerHour() == null || jobInfo.getSalaryPerHour() < 0) {
            throw new IllegalArgumentException("Invalid salary!");
        }

        if (jobInfo.getTravelPerDay() == null || jobInfo.getTravelPerDay() < 0
                || jobInfo.getTravelPerMonth() == null || jobInfo.getTravelPerMonth() < 0) {
            throw new IllegalArgumentException("Invalid travel!");
        }

        if (jobInfo.getFoodPerDay() == null || jobInfo.getFoodPerDay() < 0
                || jobInfo.getFoodPerMonth() == null || jobInfo.getFoodPerMonth() < 0) {
            throw new IllegalArgumentException("Invalid food!");
        }

        if (jobInfo.getBreakTimeMinutes() == null || jobInfo.getBreakTimeMinutes() < 0
                || jobInfo.getMinHoursBreakTime() == null || jobInfo.getMinHoursBreakTime() < 0) {
            throw new IllegalArgumentException("Invalid break time!");
        }

        if (jobInfo.getDayWorkHours() == null || jobInfo.getDayWorkHours() < 0 || jobInfo.getDayWorkHours() > 24) {
            throw new IllegalArgumentException("Invalid day work hours!");
        }

        if (jobInfo.getShifts()) {
            ShiftsInfo shiftsInfo = jobInfo.getShiftsInfo();
            if (shiftsInfo.eveningPercentage < 0 || shiftsInfo.nightPercentage < 0) {
                throw new IllegalArgumentException("Invalid shifts percentages!");
            }

            if (!(shiftsInfo.morningStartHour.isBefore(shiftsInfo.eveningStartHour)
                    && shiftsInfo.eveningStartHour.isBefore(shiftsInfo.nightStartHour))) {
                throw new IllegalArgumentException("Invalid shifts start hours!");
            }
        }

        if (jobInfo.getOverTimeInfo() == null) {
            throw new IllegalArgumentException("Invalid overtime info!");
        } else {
            OverTimeInfo overTimeInfo = jobInfo.getOverTimeInfo();

            if (!(overTimeInfo.overTimeStartHour125.isBefore(overTimeInfo.overTimeStartHour150)
                    && overTimeInfo.overTimeStartHour150.isBefore(overTimeInfo.overTimeStartHour200))) {
                throw new IllegalArgumentException("Invalid overtime start hours!");
            }
        }

        if (jobInfo.getWeekEndInfo() == null) {
            throw new IllegalArgumentException("Invalid weekends info!");
        } else {
            WeekEndInfo weekEndInfo = jobInfo.getWeekEndInfo();
            if (weekEndInfo.weekEndStartHour == null || weekEndInfo.weekEndEndHour == null) {
                throw new IllegalArgumentException("Invalid weekends start and end hours!");
            }

            if (weekEndInfo.weekEndPercentage < 0) {
                throw new IllegalArgumentException("Invalid weekends percentage!");
            }
        }

        if (jobInfo.getCurrStart() != null && jobInfo.getCurrStart().isAfter(OffsetDateTime.now())) {
            throw new IllegalArgumentException("Invalid current start work day!");
        }
    }
}
