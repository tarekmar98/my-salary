package my_salary.classes;

import lombok.Data;

import java.time.LocalTime;

@Data
public class ShiftsInfo {
    public Float eveningPercentage;
    public Float nightPercentage;
    public LocalTime morningStartHour;
    public LocalTime eveningStartHour;
    public LocalTime nightStartHour;

    @Override
    public String toString() {
        return "ShiftsInfo{" + "eveningPercentage=" + eveningPercentage + ", nightPercentage=" + nightPercentage + ", morningStartHour=" + morningStartHour + ", eveningStartHour=" + eveningStartHour + ", nightStartHour=" + nightStartHour + '}';
    }
}
