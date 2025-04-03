package my_salary.service;

import my_salary.entity.JobInfo;
import my_salary.entity.WorkDay;
import my_salary.repository.WorkDayRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.time.YearMonth;
import java.util.List;


@Service
public class WorkDayService {
    @Autowired
    private WorkDayRepository workDayRepository;

    @Autowired
    private JobInfoService jobInfoService;

    @Autowired
    private ResourcesService resourcesService;

    public WorkDay startWorkDay(Long jobId, String workType, String phoneNumber) {
        JobInfo jobInfo = jobInfoService.getJobById(jobId);
        jobInfoService.validate(jobInfo, phoneNumber);
        if (jobInfo.getCurrStart() == null) {
            jobInfo.setCurrStart(OffsetDateTime.now());
            jobInfo.setCurrWorkType(workType);
            jobInfoService.validate(jobInfo, phoneNumber);
            jobInfoService.updateJob(jobInfo, phoneNumber);
            return null;
        } else {
            if (!workType.equals(jobInfo.getCurrWorkType())) {
                throw new IllegalArgumentException("Invalid work type!");
            }

            YearMonth salaryMonth = YearMonth.from(jobInfo.getCurrStart());
            WorkDay workDay = new WorkDay(jobId, salaryMonth.getYear(), salaryMonth.getMonth().getValue(), jobInfo.getCurrStart().toLocalDate(),
                                            workType, jobInfo.getCurrStart(), OffsetDateTime.now());
            validate(workDay, phoneNumber);
            jobInfo.setCurrStart(null);
            jobInfo.setCurrWorkType(workType);
            jobInfoService.validate(jobInfo, phoneNumber);
            workDayRepository.save(workDay);
            jobInfoService.updateJob(jobInfo, phoneNumber);
            return workDay;
        }
    }

    public List<WorkDay> myWorkDays(Long jobId, int salaryMonth, int salaryYear, String phoneNumber) {
        JobInfo jobInfo = jobInfoService.getJobById(jobId);
        jobInfoService.validate(jobInfo, phoneNumber);
        return workDayRepository.findByJobIdSalaryMonth(jobId, salaryMonth, salaryYear);
    }

    public WorkDay addWorkDay(WorkDay workDay, String phoneNumber) {
        validate(workDay, phoneNumber);
        workDayRepository.save(workDay);
        return workDay;
    }

    public void deleteWorkDay(Long id) {
        WorkDay workDay = workDayRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Job does not exist!"));
        workDayRepository.delete(workDay);
    }

    public void validate(WorkDay workDay, String phoneNumber) {
        JobInfo jobInfo = jobInfoService.getJobById(workDay.getJobId());
        if (!jobInfo.getUserPhoneNumber().equals(phoneNumber)) {
            throw new IllegalArgumentException("Invalid user!");
        }

        if (workDay.getStartTime() == null || workDay.getEndTime() == null
                || workDay.getStartTime().isAfter(workDay.getEndTime())) {
            throw new IllegalArgumentException("Invalid start and end time!");
        }

        if (!workDay.getSalaryMonth().equals(YearMonth.from(workDay.getWorkDate()))) {
            throw new IllegalArgumentException("Invalid salary month!");
        }

        if (!resourcesService.isValidWorkType(workDay.getWorkType())) {
            throw new IllegalArgumentException("Invalid work type!");
        }

    }
}
