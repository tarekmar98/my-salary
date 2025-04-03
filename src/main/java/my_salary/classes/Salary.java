package my_salary.classes;

public class Salary {
    public Float regularHours;
    public Float overTimeHours125;
    public Float overTimeHours150;
    public Float overTimeHours200;
    public Float weekEndHours;
    public Float sickHours;
    public Float vacationHours;
    public Float morningHours;
    public Float eveningHours;
    public Float nightHours;
    public int travelsCount;
    public Float salary;
    
    public Salary() {
        this.regularHours = 0.0f;
        this.overTimeHours125 = 0.0f;
        this.overTimeHours150 = 0.0f;
        this.overTimeHours200 = 0.0f;
        this.weekEndHours = 0.0f;
        this.sickHours = 0.0f;
        this.vacationHours = 0.0f;
        this.morningHours = 0.0f;
        this.eveningHours = 0.0f;
        this.nightHours = 0.0f;
        this.travelsCount = 0;
        this.salary = 0.0f;
    }
}
