package my_salary.repository;

import my_salary.entity.WorkDay;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.YearMonth;
import java.util.List;


public interface WorkDayRepository extends JpaRepository<WorkDay, Long> {

    @Query("SELECT w FROM WorkDay w WHERE w.jobId = :jobId AND w.workYear = :year AND w.workMonth = :month")
    List<WorkDay> findByJobIdSalaryMonth(@Param("jobId") Long jobId, @Param("month") int month, @Param("year") int year);

}
