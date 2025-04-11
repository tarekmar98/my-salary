import 'OverTimeInfo.dart';
import 'ShiftsInfo.dart';
import 'WeekEndInfo.dart';

class JobInfo {
  int? id;
  String? userPhoneNumber;
  String? employerName;
  DateTime? startDate;
  double? salaryPerHour;
  double? salaryPerDay;
  double? travelPerDay;
  double? travelPerMonth;
  double? foodPerDay;
  double? foodPerMonth;
  double? dayWorkHours;
  int? breakTimeMinutes;
  double? minHoursBreakTime;
  bool? shifts;
  ShiftsInfo? shiftsInfo;
  OverTimeInfo? overTimeInfo;
  WeekEndInfo? weekEndInfo;
  DateTime? currStart;
  String? currWorkType;

  JobInfo({
    this.id,
    this.userPhoneNumber,
    this.employerName,
    this.startDate,
    this.salaryPerHour,
    this.salaryPerDay,
    this.travelPerDay,
    this.travelPerMonth,
    this.foodPerDay,
    this.foodPerMonth,
    this.dayWorkHours,
    this.breakTimeMinutes,
    this.minHoursBreakTime,
    this.shifts,
    this.shiftsInfo,
    this.overTimeInfo,
    this.weekEndInfo,
  });

  factory JobInfo.fromJson(Map<String, dynamic> json) {
    return JobInfo(
      id: (json['id'] as int).toInt(),
      userPhoneNumber: json['userPhoneNumber'],
      employerName: json['employerName'],
      startDate: DateTime.parse(json['startDate']),
      salaryPerHour: (json['salaryPerHour'] as num?)?.toDouble(),
      salaryPerDay: (json['salaryPerDay'] as num?)?.toDouble(),
      travelPerDay: (json['travelPerDay'] as num?)?.toDouble(),
      travelPerMonth: (json['travelPerMonth'] as num?)?.toDouble(),
      foodPerDay: (json['foodPerDay'] as num?)?.toDouble(),
      foodPerMonth: (json['foodPerMonth'] as num?)?.toDouble(),
      dayWorkHours: (json['dayWorkHours'] as num?)?.toDouble(),
      breakTimeMinutes: (json['breakTimeMinutes'] as int?)?.toInt(),
      minHoursBreakTime: (json['minHoursBreakTime'] as num?)?.toDouble(),
      shifts: json['shifts'],
      shiftsInfo: json['shiftsInfo'] != null ? ShiftsInfo.fromJson(json['shiftsInfo']) : null,
      overTimeInfo: json['overTimeInfo'] != null ? OverTimeInfo.fromJson(json['overTimeInfo']) : null,
      weekEndInfo: json['weekEndInfo'] != null ? WeekEndInfo.fromJson(json['weekEndInfo']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userPhoneNumber': userPhoneNumber,
      'employerName': employerName,
      'startDate': startDate?.toIso8601String(),
      'salaryPerHour': salaryPerHour,
      'salaryPerDay': salaryPerDay,
      'travelPerDay': travelPerDay,
      'travelPerMonth': travelPerMonth,
      'foodPerDay': foodPerDay,
      'foodPerMonth': foodPerMonth,
      'dayWorkHours': dayWorkHours,
      'breakTimeMinutes': breakTimeMinutes,
      'minHoursBreakTime': minHoursBreakTime,
      'shifts': shifts,
      'shiftsInfo': shiftsInfo?.toJson(),
      'overTimeInfo': overTimeInfo?.toJson(),
      'weekEndInfo': weekEndInfo?.toJson(),
    };
  }
}
