package my_salary.classes;

import lombok.Data;

import java.time.OffsetDateTime;

@Data
public class WeekEndInfo {
    public OffsetDateTime weekEndStartHour;
    public OffsetDateTime weekEndEndHour;
    public Float weekEndPercentage;

    @Override
    public String toString() {
        return "WeekEndInfo{" + "weekEndStartHour=" + weekEndStartHour + ", weekEndEndHour=" + weekEndEndHour + ", weekEndPercentage=" + weekEndPercentage + '}';
    }
}


