class WeekEndInfo {
  double? weekEndStartHour;
  double? weekEndEndHour;
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
    return WeekEndInfo(
      weekEndStartHour: (json['weekEndStartHour'] as num?)?.toDouble(),
      weekEndEndHour: (json['weekEndEndHour'] as num?)?.toDouble(),
      weekEndPercentage: (json['weekEndPercentage'] as num?)?.toDouble(),
      weekEndStartDay: json['weekEndStartDay'],
      weekEndEndDay: json['weekEndEndDay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekEndStartHour': weekEndStartHour,
      'weekEndEndHour': weekEndEndHour,
      'weekEndPercentage': weekEndPercentage,
      'weekEndStartDay': weekEndStartDay,
      'weekEndEndDay': weekEndEndDay,
    };
  }
}