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
    DateFormat format = DateFormat("HH:mm:ss");
    return {
      'eveningPercentage': eveningPercentage,
      'nightPercentage': nightPercentage,
      'morningStartHour': morningStartHour != null ? format.format(morningStartHour!) : "00:00:00",
      'eveningStartHour': eveningStartHour != null ? format.format(eveningStartHour!) : "00:00:00",
      'nightStartHour': nightPercentage != null ? format.format(nightStartHour!) : "00:00:00",
    };
  }
}