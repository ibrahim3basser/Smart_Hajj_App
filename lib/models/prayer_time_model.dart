class PrayerTimesResponse {
  final int code;
  final String status;
  final List<PrayerDay> data;

  PrayerTimesResponse({required this.code, required this.status, required this.data});

  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) {
    return PrayerTimesResponse(
      code: json['code'],
      status: json['status'],
      data: (json['data'] as List)
          .map((dayJson) => PrayerDay.fromJson(dayJson))
          .toList(),
    );
  }
}

class PrayerDay {
  final Map<String, String> timings;
  final DateInfo date;

  PrayerDay({required this.timings, required this.date});

  factory PrayerDay.fromJson(Map<String, dynamic> json) {
    return PrayerDay(
      timings: Map<String, String>.from(json['timings']),
      date: DateInfo.fromJson(json['date']),
    );
  }
}

class DateInfo {
  final String date;
  final String hijri;
  final String en;
  final String ar;

  DateInfo({required this.date, required this.hijri, required this.en, required this.ar});

  factory DateInfo.fromJson(Map<String, dynamic> json) {
    return DateInfo(
      date: json['date'],
      hijri: json['hijri'],
      en: json['en'],
      ar: json['ar'],
    );
  }
}
