import 'package:intl/intl.dart';

class OverTimeInfo {
  DateTime? overTimeStartHour125;
  DateTime? overTimeStartHour150;
  DateTime? overTimeStartHour200;

  OverTimeInfo({
    this.overTimeStartHour125,
    this.overTimeStartHour150,
    this.overTimeStartHour200,
  });

  factory OverTimeInfo.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat("HH:mm:ss");
    return OverTimeInfo(
      overTimeStartHour125: format.parse(json['overTimeStartHour125']),
      overTimeStartHour150: format.parse(json['overTimeStartHour150']),
      overTimeStartHour200: format.parse(json['overTimeStartHour200']),
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat format = DateFormat("HH:mm:ss");
    return {
      'overTimeStartHour125': format.format(overTimeStartHour125!),
      'overTimeStartHour150': format.format(overTimeStartHour150!),
      'overTimeStartHour200': format.format(overTimeStartHour200!),
    };
  }
}