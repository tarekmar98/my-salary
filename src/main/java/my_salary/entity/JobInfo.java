package my_salary.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import my_salary.classes.*;
import my_salary.converter.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDate;
import java.time.OffsetDateTime;


@Getter
@Setter
@Entity
@Table(name = "job_info")
public class JobInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String userPhoneNumber;
    private String employerName;
    private LocalDate startDate;
    private Float salaryPerHour;
    private Float salaryPerDay;
    private Float travelPerDay;
    private Float travelPerMonth;
    private Float foodPerDay;
    private Float foodPerMonth;
    private Integer breakTimeMinutes;
    private Float minHoursBreakTime;
    private Boolean shifts;

    @Column(name = "shifts_info", columnDefinition = "jsonb")
    @Convert(converter = ShiftsInfoConverter.class)
    @JdbcTypeCode(SqlTypes.JSON)
    private ShiftsInfo shiftsInfo;

    @Column(name = "over_time_info", columnDefinition = "jsonb")
    @Convert(converter = OverTimeInfoConverter.class)
    @JdbcTypeCode(SqlTypes.JSON)
    private OverTimeInfo overTimeInfo;

    @Column(name = "week_end_info", columnDefinition = "jsonb")
    @Convert(converter = WeekEndInfoConverter.class)
    @JdbcTypeCode(SqlTypes.JSON)
    private WeekEndInfo weekEndInfo;

    @Column(name = "curr_start", nullable = true)
    private OffsetDateTime currStart;
    
    public JobInfo() {}

    @Override
    public String toString() {
        return "JobInfo{" +
                "id='" + id + '\'' +
                ", userPhoneNumber='" + userPhoneNumber + '\'' +
                ", employerName='" + employerName + '\'' +
                ", startDate=" + startDate +
                ", salaryPerHour=" + salaryPerHour +
                ", salaryPerDay=" + salaryPerDay +
                ", travelPerDay=" + travelPerDay +
                ", travelPerMonth=" + travelPerMonth +
                ", foodPerDay=" + foodPerDay +
                ", foodPerMonth=" + foodPerMonth +
                ", breakTimeMinutes=" + breakTimeMinutes +
                ", minHoursBreakTime=" + minHoursBreakTime +
                ", shifts=" + shifts +
                ", shiftsInfo=" + shiftsInfo +
                ", overTimeInfo=" + overTimeInfo +
                ", weekEndInfo=" + weekEndInfo +
                ", currStart=" + currStart +
                '}';
    }
}
