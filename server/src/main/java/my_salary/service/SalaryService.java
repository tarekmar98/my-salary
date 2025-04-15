package my_salary.service;

import my_salary.classes.Salary;
import my_salary.classes.ShiftsPercentage;
import my_salary.classes.WeekEndInfo;
import my_salary.entity.JobInfo;
import my_salary.entity.WorkDay;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.util.Pair;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.DayOfWeek;
import java.time.Duration;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalTime;


@Service
public class SalaryService {
    @Autowired
    private JobInfoService jobInfoService;

    @Autowired
    private WorkDayService workDayService;

    public void updateToLocalTime(List<WorkDay> workDays) {
        for (WorkDay workDay: workDays) {
            OffsetDateTime start = workDay.getStartTime();
            start = start.plusHours(workDay.getTimeDiffUtc().longValue());
            start = start.plusHours((workDay.getTimeDiffUtc().longValue() * 60) % 60);
            workDay.setStartTime(start);
            OffsetDateTime end = workDay.getEndTime();
            end = end.plusHours(workDay.getTimeDiffUtc().longValue());
            end = end.plusHours((workDay.getTimeDiffUtc().longValue() * 60) % 60);
            workDay.setEndTime(end);
        }
    }

    public Salary calcSalaryInfo(Long jobId, int month, int year, String phoneNumber) {
        JobInfo jobInfo = jobInfoService.getJobById(jobId);
        List<WorkDay> workDays = workDayService.myWorkDays(jobId, month, year, phoneNumber);
        updateToLocalTime(workDays);
        Salary salary = new Salary();
        salary.salary = calcTravels(jobInfo, workDays, salary);
        salary.salary += calcFood(jobInfo, workDays);
        int sickDays = countWorkType(workDays, "sickDay");
        int vacationDays = countWorkType(workDays, "vacationDay");
        if (jobInfo.getSalaryPerDay() != 0) {
            salary.salary += workDays.size() * jobInfo.getSalaryPerDay();
            salary.sickHours = sickDays * jobInfo.getDayWorkHours();
            salary.vacationHours = vacationDays * jobInfo.getDayWorkHours();
        } else {
            salary.sickHours = sickDays * jobInfo.getDayWorkHours();
            salary.vacationHours = vacationDays * jobInfo.getDayWorkHours();
            salary.salary += (salary.vacationHours + salary.sickHours) * jobInfo.getSalaryPerHour();
            List<List<Pair<OffsetDateTime, OffsetDateTime>>> overTimeRanges = calcWorkDayOverTime(workDays, jobInfo);
            List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>> shiftsRanges = calcShifts(overTimeRanges, jobInfo);
            List<List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>>> rangesWithWeekend = calcWithWeekEnds(shiftsRanges, jobInfo);
            updateSalary(jobInfo, rangesWithWeekend, salary);
        }

        return salary;
    }

    public void updateSalary(
            JobInfo jobInfo, List<List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>>> ranges,
            Salary salary
    ) {
        Float percentage = 1.0f;
        for (List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>> range : ranges) {
            for (int i = 0; i < range.size(); i++) {
                List<List<Pair<OffsetDateTime, OffsetDateTime>>> overTimeRange = range.get(i);
                Float overTimePercentage = 1.0f;
                if (i == 1) {
                    overTimePercentage = 1.25f;
                } else if (i == 2) {
                    overTimePercentage = 1.5f;
                } else if (i == 3) {
                    overTimePercentage = 2.0f;
                }

                percentage *= overTimePercentage;
                for (int j = 0; j < overTimeRange.size(); j++) {
                    List<Pair<OffsetDateTime, OffsetDateTime>> shiftsRange = overTimeRange.get(j);
                    Float shiftPercentage = 1.0f;
                    if (j == 1) {
                        shiftPercentage = jobInfo.getShiftsInfo().eveningPercentage;
                    } else if (j == 2) {
                        shiftPercentage = jobInfo.getShiftsInfo().nightPercentage;
                    }

                    percentage *= shiftPercentage;
                    for (int l = 0; l < shiftsRange.size(); l++) {
                        if (shiftsRange.get(l) == null) {
                            continue;
                        }

                        Pair<OffsetDateTime, OffsetDateTime> rangeDay = shiftsRange.get(l);
                        Duration duration = Duration.between(rangeDay.getFirst(), rangeDay.getSecond());
                        float hours = duration.toSeconds() / (60.0f * 60.0f);
                        hours = new BigDecimal(Float.toString(hours))
                                .setScale(2, RoundingMode.HALF_UP)
                                .floatValue();

                        if (l == 2) {
                            salary.salary += percentage * jobInfo.getWeekEndInfo().weekEndPercentage * hours * jobInfo.getSalaryPerHour();
                            salary.weekEndHours += hours;
                        } else {
                            salary.salary += percentage * hours * jobInfo.getSalaryPerHour();
                        }

                        updateHours(salary, hours, j, i);
                    }

                    percentage /= shiftPercentage;
                }

                percentage /= overTimePercentage;
            }
        }
    }

    public List<List<Pair<OffsetDateTime, OffsetDateTime>>> calcWorkDayOverTime(List<WorkDay> workDays, JobInfo jobInfo) {
        List<List<Pair<OffsetDateTime, OffsetDateTime>>> workDayOverTimeRanges = new ArrayList<>();
        for (WorkDay workDay: workDays) {
            Pair<OffsetDateTime, OffsetDateTime> rangeDay = Pair.of(workDay.getStartTime(), workDay.getEndTime());
            Duration duration = Duration.between(rangeDay.getFirst(), rangeDay.getSecond());
            float hours = duration.toSeconds() / (60.0f * 60.0f);
            if (hours >= jobInfo.getMinHoursBreakTime()) {
                rangeDay = Pair.of(rangeDay.getFirst().plusMinutes(jobInfo.getBreakTimeMinutes()), rangeDay.getSecond());
                hours -= (jobInfo.getBreakTimeMinutes() / 60.0f);
            }

            List<Pair<OffsetDateTime, OffsetDateTime>> overTimeRange = new ArrayList<>();
            if (hours <= jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage125)) {
                overTimeRange.add(rangeDay);
            } else {
                OffsetDateTime start = rangeDay.getFirst();
                long additionalHours = jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage125).longValue();
                long additionalMinutes = Math.round((jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage125) - additionalHours) * 60);
                OffsetDateTime end = start.plusHours(additionalHours).plusMinutes(additionalMinutes);
                overTimeRange.add(Pair.of(start, end));

                if (hours <= jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage150)) {
                    overTimeRange.add(Pair.of(end, rangeDay.getSecond()));
                } else {

                    additionalHours = jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage150).longValue()
                            - jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage125).longValue();
                    additionalMinutes = Math.round((jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage150)
                            - jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage150).longValue()
                            - additionalHours) * 60);
                    OffsetDateTime nextEnd = end.plusHours(additionalHours).plusMinutes(additionalMinutes);
                    overTimeRange.add(Pair.of(end, nextEnd));
                    end = nextEnd;

                    if (hours <= jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage200)) {
                        overTimeRange.add(Pair.of(end, rangeDay.getSecond()));
                    } else {

                        additionalHours = jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage200).longValue()
                                - jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage150).longValue();
                        additionalMinutes = Math.round((jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage200)
                                - jobInfo.getOverTimeInfo().timeConverter(ShiftsPercentage.percentage150).longValue()
                                - additionalHours) * 60);
                        nextEnd = end.plusHours(additionalHours).plusMinutes(additionalMinutes);
                        overTimeRange.add(Pair.of(end, nextEnd));
                        overTimeRange.add(Pair.of(nextEnd, rangeDay.getSecond()));
                    }
                }
            }

            workDayOverTimeRanges.add(overTimeRange);
        }

        return workDayOverTimeRanges;
    }

    public List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>> calcShifts(
            List<List<Pair<OffsetDateTime, OffsetDateTime>>> overTimeRanges,
            JobInfo jobInfo
    ) {
        List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>> shiftsRanges = new ArrayList<>();
        if (jobInfo.getShifts()) {
            for (List<Pair<OffsetDateTime, OffsetDateTime>> workDay : overTimeRanges) {
                List<List<Pair<OffsetDateTime, OffsetDateTime>>> overTimeRange = new ArrayList<>();
                for (Pair<OffsetDateTime, OffsetDateTime> range : workDay) {
                    List<Pair<OffsetDateTime, OffsetDateTime>> shiftsRange = new ArrayList<>();
                    shiftsRange.add(cropToLocalTimeRange(range.getFirst(), range.getSecond(),
                            jobInfo.getShiftsInfo().morningStartHour, jobInfo.getShiftsInfo().eveningStartHour));

                    shiftsRange.add(cropToLocalTimeRange(range.getFirst(), range.getSecond(),
                            jobInfo.getShiftsInfo().eveningStartHour, jobInfo.getShiftsInfo().nightStartHour));

                    Pair<OffsetDateTime, OffsetDateTime> firstNightShift = cropToLocalTimeRange(range.getFirst(), range.getSecond(),
                            jobInfo.getShiftsInfo().nightStartHour, LocalTime.of(23, 59));

                    Pair<OffsetDateTime, OffsetDateTime> updatedNightShift;
                    if (firstNightShift != null) {
                        Pair<OffsetDateTime, OffsetDateTime> secondNightShift = cropToLocalTimeRange(range.getFirst(), range.getSecond(),
                                LocalTime.of(0, 0), jobInfo.getShiftsInfo().morningStartHour);

                        if (secondNightShift == null) {
                            updatedNightShift = firstNightShift;
                        } else {
                            updatedNightShift = Pair.of(firstNightShift.getFirst(), secondNightShift.getSecond());
                        }
                    } else {
                        updatedNightShift = cropToLocalTimeRange(range.getFirst(), range.getSecond(),
                                LocalTime.of(0, 0), jobInfo.getShiftsInfo().morningStartHour);
                    }

                    shiftsRange.add(updatedNightShift);
                    overTimeRange.add(shiftsRange);
                }
                shiftsRanges.add(overTimeRange);
            }
        } else {
            for (List<Pair<OffsetDateTime, OffsetDateTime>> workDay : overTimeRanges) {
                List<List<Pair<OffsetDateTime, OffsetDateTime>>> overTimeRange = new ArrayList<>();
                for (Pair<OffsetDateTime, OffsetDateTime> range : workDay) {
                    List<Pair<OffsetDateTime, OffsetDateTime>> shiftsRange = new ArrayList<>();
                    shiftsRange.add(range);
                    overTimeRange.add(shiftsRange);
                }
                shiftsRanges.add(overTimeRange);
            }
        }

        return shiftsRanges;
    }

    public Pair<OffsetDateTime, OffsetDateTime> cropToLocalTimeRange(
            OffsetDateTime originalStart,
            OffsetDateTime originalEnd,
            LocalTime validStartLocalTime,
            LocalTime validEndLocalTime
    ) {
        OffsetDateTime adjustedStart = originalStart;
        if (originalStart.toLocalTime().isBefore(validStartLocalTime)) {
            adjustedStart = originalStart.with(validStartLocalTime);
        } else if (originalStart.toLocalTime().isAfter(validEndLocalTime)) {
            adjustedStart = originalStart.plusDays(1).with(validStartLocalTime);
        }

        OffsetDateTime adjustedEnd = originalEnd;
        if (originalEnd.toLocalTime().isAfter(validEndLocalTime)) {
            adjustedEnd = originalEnd.with(validEndLocalTime);
        } else if (originalEnd.toLocalTime().isBefore(validStartLocalTime)) {
            adjustedEnd = originalEnd.minusDays(1).with(validEndLocalTime);
        }

        if (adjustedStart.isAfter(adjustedEnd)) {
            return null;
        }

        return Pair.of(adjustedStart, adjustedEnd);
    }

    public Float calcTravels(JobInfo jobInfo, List<WorkDay> workDays, Salary salary) {
        int counter = countWorkType(workDays, "workFromOffice");
        salary.travelsCount = counter;
        if (jobInfo.getTravelPerDay() == 0) {
            return jobInfo.getTravelPerMonth();
        } else {
            return jobInfo.getTravelPerDay() * counter;
        }
    }

    public Float calcFood(JobInfo jobInfo, List<WorkDay> workDays) {
        if (jobInfo.getFoodPerDay() == 0) {
            return jobInfo.getFoodPerMonth();
        } else {
            int counter = countWorkType(workDays, "workFromOffice")
                    + countWorkType(workDays, "workFromHome");
            return jobInfo.getFoodPerDay() * counter;
        }
    }

    public int countWorkType(List<WorkDay> workDays, String workType) {
        int counter = 0;
        for (WorkDay workDay : workDays) {
            if (workDay.getWorkType().equals(workType)) {
                counter++;
            }
        }

        return counter;
    }

    public List<List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>>> calcWithWeekEnds(
            List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>> shiftsRanges,
            JobInfo jobInfo
    ) {
        List<List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>>> withWeekEndsRanges = new ArrayList<>();
        for (List<List<Pair<OffsetDateTime, OffsetDateTime>>> workDay : shiftsRanges) {
            List<List<List<Pair<OffsetDateTime, OffsetDateTime>>>> workDayWithWeekend = new ArrayList<>();
            for (List<Pair<OffsetDateTime, OffsetDateTime>> shiftDay : workDay) {
                List<List<Pair<OffsetDateTime, OffsetDateTime>>> shiftDayWithWeekend = new ArrayList<>();
                for (Pair<OffsetDateTime, OffsetDateTime> shift : shiftDay) {
                    if (shift == null) {
                        shiftDayWithWeekend.add(new ArrayList<>());
                        continue;
                    }

                    List<Pair<OffsetDateTime, OffsetDateTime>> shiftWithWeekend = new ArrayList<>();
                    Pair<OffsetDateTime, OffsetDateTime> intersectionWithWeekend = intersectionWithWeekend(
                            shift.getFirst(),
                            shift.getSecond(),
                            jobInfo.getWeekEndInfo()
                    );

                    if (intersectionWithWeekend == null) {
                        shiftWithWeekend.add(shift);
                    } else {
                        List<Pair<OffsetDateTime, OffsetDateTime>> shiftedRange = subtractRange(shift, intersectionWithWeekend);
                        if (shiftedRange.isEmpty()) {
                            shiftWithWeekend.add(null);
                        } else {
                            shiftWithWeekend.addAll(shiftedRange);
                        }

                        shiftWithWeekend.add(intersectionWithWeekend);
                    }

                    shiftDayWithWeekend.add(shiftWithWeekend);
                }

                workDayWithWeekend.add(shiftDayWithWeekend);
            }

            withWeekEndsRanges.add(workDayWithWeekend);
        }

        return withWeekEndsRanges;
    }

    public Pair<OffsetDateTime, OffsetDateTime> intersectionWithWeekend(
            OffsetDateTime intervalStart,
            OffsetDateTime intervalEnd,
            WeekEndInfo weekEndInfo
    ) {
        OffsetDateTime weekendStart = getWeekdayHour(intervalStart, weekEndInfo.weekEndStartDay, weekEndInfo.weekEndStartHour);
        OffsetDateTime weekendEnd = getWeekdayHour(intervalStart, weekEndInfo.weekEndEndDay, weekEndInfo.weekEndEndHour);
        OffsetDateTime intersectionStart = intervalStart.isAfter(weekendStart) ? intervalStart : weekendStart;
        OffsetDateTime intersectionEnd = intervalEnd.isBefore(weekendEnd) ? intervalEnd : weekendEnd;

        if (intersectionStart.isAfter(intersectionEnd)) {
            return null;
        }

        return Pair.of(intersectionStart, intersectionEnd);
    }

    public OffsetDateTime getWeekdayHour(OffsetDateTime reference, DayOfWeek targetDay, LocalTime fractionalHour) {
        int dayDiff = targetDay.getValue() - reference.getDayOfWeek().getValue();

        OffsetDateTime targetDateTime = reference.plusDays(dayDiff)
                .withHour(fractionalHour.getHour()).withMinute(fractionalHour.getMinute());

        return targetDateTime;
    }

    public List<Pair<OffsetDateTime, OffsetDateTime>> subtractRange(
            Pair<OffsetDateTime, OffsetDateTime> mainRange,
            Pair<OffsetDateTime, OffsetDateTime> subtractRange
    ) {
        List<Pair<OffsetDateTime, OffsetDateTime>> resultingRanges = new ArrayList<>();

        if (mainRange.getSecond().isBefore(subtractRange.getFirst()) || mainRange.getFirst().isAfter(subtractRange.getSecond())) {
            resultingRanges.add(Pair.of(mainRange.getFirst(), mainRange.getSecond()));
            return resultingRanges;
        }

        if (mainRange.getFirst().isBefore(subtractRange.getFirst())) {
            resultingRanges.add(Pair.of(mainRange.getFirst(), subtractRange.getFirst()));
        } else {
            resultingRanges.add(null);
        }

        if (mainRange.getSecond().isAfter(subtractRange.getSecond())) {
            resultingRanges.add(Pair.of(subtractRange.getSecond(), mainRange.getSecond()));
        } else {
            resultingRanges.add(null);
        }

        return resultingRanges;
    }

    public void updateHours(Salary salary, Float hours, int shift, int overTime) {
        switch (shift) {
            case 0:
                salary.morningHours += hours;
                break;
            case 1:
                salary.eveningHours += hours;
                break;
            case 2:
                salary.nightHours += hours;
        }

        switch (overTime) {
            case 0:
                salary.regularHours += hours;
                break;
            case 1:
                salary.overTimeHours125 += hours;
                break;
            case 2:
                salary.overTimeHours150 += hours;
                break;
            case 3:
                salary.overTimeHours200 += hours;
                break;
        }
    }


}
