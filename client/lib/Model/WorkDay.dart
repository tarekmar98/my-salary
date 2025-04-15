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
  double? timeDiffUtc;

  WorkDay({
    this.id,
    this.jobId,
    this.workYear,
    this.workMonth,
    this.workDate,
    this.workType,
    this.startTime,
    this.endTime,
    this.timeDiffUtc
  });

  factory WorkDay.fromJson(Map<String, dynamic> json) {
    DateTime startTime = DateTime.parse(json['startTime']).toUtc().toLocal();
    return WorkDay(
      id: (json['id'] as int).toInt(),
      jobId: (json['jobId'] as int).toInt(),
      workYear: (json['workYear'] as int).toInt(),
      workMonth: (json['workMonth'] as int).toInt(),
      workDate: DateTime(startTime.year, startTime.month, startTime.day).toUtc().toLocal(),
      workType: json['workType'],
      startTime: startTime,
      endTime: DateTime.parse(json['endTime']).toUtc().toLocal(),
      timeDiffUtc: (json['timeDiffUtc'] as double).toDouble()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'workYear': workYear,
      'workMonth': workMonth,
      'workType': workType,
      'startTime': startTime?.toUtc().toIso8601String(),
      'endTime': endTime?.toUtc().toIso8601String(),
      'timeDiffUtc': timeDiffUtc
    };
  }
}