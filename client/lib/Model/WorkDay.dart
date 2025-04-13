import 'dart:core';

class WorkDay {
  int? id;
  int? jobId;
  int? workYear;
  int? workMonth;
  DateTime? workDate;
  String? workType;
  DateTime? startTime;
  DateTime? endTime;

  WorkDay({
    this.id,
    this.jobId,
    this.workYear,
    this.workMonth,
    this.workDate,
    this.workType,
    this.startTime,
    this.endTime,
  });

  factory WorkDay.fromJson(Map<String, dynamic> json) {
    return WorkDay(
      id: (json['id'] as int).toInt(),
      jobId: (json['jobId'] as int).toInt(),
      workYear: (json['workYear'] as int).toInt(),
      workMonth: (json['workMonth'] as int).toInt(),
      workDate: DateTime.parse(json['workDate']).toLocal(),
      workType: json['workType'],
      startTime: DateTime.parse(json['startTime']).toLocal(),
      endTime: DateTime.parse(json['endTime']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'workYear': workYear,
      'workMonth': workMonth,
      'workDate': workDate?.toLocal().toIso8601String(),
      'workType': workType,
      'startTime': startTime?.toLocal().toIso8601String(),
      'endTime': endTime?.toLocal().toIso8601String(),
    };
  }
}