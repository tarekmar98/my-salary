package my_salary.classes;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.time.LocalTime;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class OverTimeInfo {
    public LocalTime overTimeStartHour125;
    public LocalTime overTimeStartHour150;
    public LocalTime overTimeStartHour200;

    @Override
    public String toString() {
        return "OverTimeInfo{" + "overTimeStartHour125=" + overTimeStartHour125 + ", overTimeStartHour150=" + overTimeStartHour150 + ", overTimeStartHour200=" + overTimeStartHour200;
    }

    public Float timeConverter(ShiftsPercentage percentage) {
        if (percentage == ShiftsPercentage.percentage125) {
            return (float) (overTimeStartHour125.getHour() + overTimeStartHour125.getMinute() / 60.0);
        } else if (percentage == ShiftsPercentage.percentage150) {
            return (float) (overTimeStartHour150.getHour() + overTimeStartHour150.getMinute() / 60.0);
        } else {
            return (float) (overTimeStartHour200.getHour() + overTimeStartHour200.getMinute() / 60.0);

        }
    }
}
