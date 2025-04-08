class OverTimeInfo {
  double? overTimeStartHour125;
  double? overTimeStartHour150;
  double? overTimeStartHour200;

  OverTimeInfo({
    this.overTimeStartHour125,
    this.overTimeStartHour150,
    this.overTimeStartHour200,
  });

  factory OverTimeInfo.fromJson(Map<String, dynamic> json) {
    return OverTimeInfo(
      overTimeStartHour125: (json['overTimeStartHour125'] as num?)?.toDouble(),
      overTimeStartHour150: (json['overTimeStartHour150'] as num?)?.toDouble(),
      overTimeStartHour200: (json['overTimeStartHour200'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overTimeStartHour125': overTimeStartHour125,
      'overTimeStartHour150': overTimeStartHour150,
      'overTimeStartHour200': overTimeStartHour200,
    };
  }
}