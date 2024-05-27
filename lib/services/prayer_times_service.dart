import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pray_times/pray_times.dart';
import 'package:intl/intl.dart';

class PrayerTimeService {
  static PrayerTimeService? _instance;

  static PrayerTimeService get instance {
    _instance ??= PrayerTimeService();
    return _instance!;
  }

  List<String> prayerNamesEn = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  List<String> prayerNamesAr = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];

  List<PrayerTimesModel> times = [];

  Future getPrayersTimes() async {
    // times = [];
    await _determinePosition().then((pos) {
      PrayerTimes pray = PrayerTimes();
      pray.setTimeFormat(pray.Time12);
      pray.setCalcMethod(pray.Makkah);
      // pray.setCalcMethod(pray.Egypt);
      pray.setAsrJuristic(pray.Shafii);
      pray.setAdjustHighLats(pray.AngleBased);
      // {Fajr,Sunrise,Dhuhr,Asr,Sunset,Maghrib,Isha}
      var offsets = [0, 0, 0, 0, 0, 0, 0];
      pray.tune(offsets);
      final date = DateTime.now();
      // final date = DateTime(2023, DateTime.january, 20);
      var timesOnly = pray.getPrayerTimes(date, pos.latitude, pos.longitude, 3);
      List<String> prayerNames = pray.getTimeNames();
      for (int i = 0; i < prayerNames.length; i++) {
        times.add(PrayerTimesModel(name: prayerNames[i], time: timesOnly[i]));
      }
    }, onError: (e) {
      debugPrint(e.toString());
    });
  }

  Future<PrayerTimesModel> getCurrentPrayerTime() async {
    if (times.isEmpty) {
      await getPrayersTimes();
    }

    return times.firstWhere((element) => element.checkIfPassed());
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}

class MyLocation {
  final double lat;
  final double lng;

  const MyLocation({required this.lat, required this.lng});
}

class PrayerTimesModel {
  final String name;
  final String time;
  bool isPassed = false;
  String timeDifference = '0';

  PrayerTimesModel(
      {required this.name, required this.time, this.isPassed = false});

  checkIfPassed() {
    final now = DateTime.now();
    // Parse the time string
    // final parsedTime = DateFormat.jm().parse(time.split(" ")[0]);

    final parsedTime = DateFormat('hh:mm a').parse(time.toUpperCase());

    final hour = parsedTime.hour;
    final minute = parsedTime.minute;

    // Construct a new DateTime object with the current date and parsed time
    final dateTime = DateTime(now.year, now.month, now.day, hour, minute);

    // Get the current time

    // Calculate the difference
    isPassed = now.isBefore(dateTime);
    final difference =
        isPassed ? const Duration(seconds: 0) : now.difference(dateTime);
    debugPrint('difference: $difference');
    if (!isPassed) {
      timeDifference = difference.inMinutes.toString();
    }

    return isPassed;
  }
}

class Name {
  String? ar;
  String? en;

  Name({required this.ar, required this.en});
}

