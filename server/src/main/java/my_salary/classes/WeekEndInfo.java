package my_salary.classes;

import lombok.Data;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.time.OffsetDateTime;

@Data
public class WeekEndInfo {
    public LocalTime weekEndStartHour;
    public DayOfWeek weekEndStartDay;
    public LocalTime weekEndEndHour;
    public DayOfWeek weekEndEndDay;
    public Float weekEndPercentage;

    @Override
    public String toString() {
        return "WeekEndInfo{" + "weekEndStartHour=" + weekEndStartHour + ", weekEndStartDay='" + weekEndStartDay + '\'' + ", weekEndEndHour=" + weekEndEndHour + ", weekEndEndDay='" + weekEndEndDay + '\'' + ", weekEndPercentage=" + weekEndPercentage + '}';
    }
}


