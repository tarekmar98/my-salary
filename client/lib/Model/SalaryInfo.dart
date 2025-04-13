import 'dart:core';

class SalaryInfo {
  double? regularHours;
  double? overTimeHours125;
  double? overTimeHours150;
  double? overTimeHours200;
  double? weekEndHours;
  double? sickHours;
  double? vacationHours;
  double? morningHours;
  double? eveningHours;
  double? nightHours;
  int? travelsCount;
  double? salary;

  SalaryInfo({
    this.regularHours,
    this.overTimeHours125,
    this.overTimeHours150,
    this.overTimeHours200,
    this.weekEndHours,
    this.sickHours,
    this.vacationHours,
    this.morningHours,
    this.eveningHours,
    this.nightHours,
    this.travelsCount,
    this.salary
  });

  factory SalaryInfo.fromJson(Map<String, dynamic> json) {
    return SalaryInfo(
      regularHours: (json['regularHours'] as double).toDouble(),
      overTimeHours125: (json['overTimeHours125'] as double).toDouble(),
      overTimeHours150: (json['overTimeHours150'] as double).toDouble(),
      overTimeHours200: (json['overTimeHours200'] as double).toDouble(),
      weekEndHours: (json['weekEndHours'] as double).toDouble(),
      sickHours: (json['sickHours'] as double).toDouble(),
      vacationHours: (json['vacationHours'] as double).toDouble(),
      morningHours: (json['morningHours'] as double).toDouble(),
      eveningHours: (json['eveningHours'] as double).toDouble(),
      nightHours: (json['nightHours'] as double).toDouble(),
      travelsCount: (json['travelsCount'] as int).toInt(),
      salary: (json['salary'] as double).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regularHours': regularHours,
      'overTimeHours125': overTimeHours125,
      'overTimeHours150': overTimeHours150,
      'overTimeHours200': overTimeHours200,
      'weekEndHours': weekEndHours,
      'sickHours': sickHours,
      'vacationHours': vacationHours,
      'morningHours': morningHours,
      'eveningHours': eveningHours,
      'nightHours': nightHours,
      'travelsCount': travelsCount,
      'salary': salary
    };
  }
}