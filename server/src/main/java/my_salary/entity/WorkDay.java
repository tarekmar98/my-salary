package my_salary.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.YearMonth;


@Getter
@Setter
@Entity
@Table(name = "work_day")
public class WorkDay {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long jobId;
    private Integer workYear;
    private Integer workMonth;
    private String workType;
    private OffsetDateTime startTime;
    private OffsetDateTime endTime;
    private Float timeDiffUtc;

    public WorkDay() {}

    public WorkDay(Long jobId, Integer workYear, Integer workMonth, String workType, OffsetDateTime startTime,
                   OffsetDateTime endTime, Float timeDiffUtc) {
        this.jobId = jobId;
        this.workYear = workYear;
        this.workMonth = workMonth;
        this.workType = workType;
        this.startTime = startTime;
        this.endTime = endTime;
        this.timeDiffUtc = timeDiffUtc;
    }

    public YearMonth getSalaryMonth() {
        return YearMonth.of(workYear, workMonth);
    }

    @Override
    public String toString() {
        return "WorkDay{" + "id=" + id + ", jobId=" + jobId + ", workYear=" + workYear + ", workMonth=" + workMonth + ", workType='" + workType + '\'' + ", startTime=" + startTime + ", endTime=" + endTime + ", timeDiffUtc=" + timeDiffUtc + '}';
    }
}
