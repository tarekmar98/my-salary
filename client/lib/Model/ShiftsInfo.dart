import 'package:intl/intl.dart';

class ShiftsInfo {
  double? eveningPercentage;
  double? nightPercentage;
  DateTime? morningStartHour;
  DateTime? eveningStartHour;
  DateTime? nightStartHour;

  ShiftsInfo({
    this.eveningPercentage,
    this.nightPercentage,
    this.morningStartHour,
    this.eveningStartHour,
    this.nightStartHour,
  });

  factory ShiftsInfo.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat("HH:mm:ss");
    return ShiftsInfo(
      eveningPercentage: (json['eveningPercentage'] as num?)?.toDouble(),
      nightPercentage: (json['nightPercentage'] as num?)?.toDouble(),
      morningStartHour: format.parse(json['morningStartHour']),
      eveningStartHour: format.parse(json['eveningStartHour']),
      nightStartHour: format.parse(json['nightStartHour']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eveningPercentage': eveningPercentage,
      'nightPercentage': nightPercentage,
      'morningStartHour': morningStartHour?.toIso8601String(),
      'eveningStartHour': eveningStartHour?.toIso8601String(),
      'nightStartHour': nightStartHour?.toIso8601String(),
    };
  }
}