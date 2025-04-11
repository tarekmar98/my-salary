import 'package:intl/intl.dart';

class WeekEndInfo {
  DateTime? weekEndStartHour;
  DateTime? weekEndEndHour;
  double? weekEndPercentage;
  String? weekEndStartDay;
  String? weekEndEndDay;

  WeekEndInfo({
    this.weekEndStartHour,
    this.weekEndEndHour,
    this.weekEndPercentage,
    this.weekEndStartDay,
    this.weekEndEndDay,
  });

  factory WeekEndInfo.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat("HH:mm:ss");
    return WeekEndInfo(
      weekEndStartHour: format.parse(json['weekEndStartHour']),
      weekEndEndHour: format.parse(json['weekEndEndHour']),
      weekEndPercentage: (json['weekEndPercentage'] as num?)?.toDouble(),
      weekEndStartDay: json['weekEndStartDay'],
      weekEndEndDay: json['weekEndEndDay'],
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat format = DateFormat("HH:mm:ss");
    return {
      'weekEndStartHour': format.format(weekEndStartHour!),
      'weekEndEndHour': format.format(weekEndEndHour!),
      'weekEndPercentage': weekEndPercentage,
      'weekEndStartDay': weekEndStartDay,
      'weekEndEndDay': weekEndEndDay,
    };
  }
}