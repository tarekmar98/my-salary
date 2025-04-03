package my_salary.classes;

import lombok.Data;

@Data
public class OverTimeInfo {
    public Float overTimeStartHour125;
    public Float overTimeStartHour150;
    public Float overTimeStartHour200;

    @Override
    public String toString() {
        return "OverTimeInfo{" + "overTimeStartHour125=" + overTimeStartHour125 + ", overTimeStartHour150=" + overTimeStartHour150 + ", overTimeStartHour200=" + overTimeStartHour200;
    }
}
