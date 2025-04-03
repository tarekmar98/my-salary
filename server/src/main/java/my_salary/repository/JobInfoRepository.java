package my_salary.repository;

import my_salary.entity.AuthUser;
import my_salary.entity.JobInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface JobInfoRepository  extends JpaRepository<JobInfo, Long> {

    @Query("SELECT j FROM JobInfo j WHERE j.userPhoneNumber = :userPhoneNumber")
    List<JobInfo> findByPhoneNumber(@Param("userPhoneNumber") String phoneNumber);
}
