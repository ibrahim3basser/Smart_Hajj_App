import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prayers_times/prayers_times.dart';

import '../container_for_next_prayer_home_body.dart'; // Ensure to add intl package to pubspec.yaml
import 'package:http/http.dart' as http;
// package 
// class NextPrayerSection extends StatefulWidget {
//   const NextPrayerSection({Key? key, this.initialDuration}) : super(key: key);

//   final Duration? initialDuration;

//   @override
//   State<NextPrayerSection> createState() => _NextPrayerSectionState();
// }

// class _NextPrayerSectionState extends State<NextPrayerSection> {
//   String nextPrayer = '';
//   late Timer _timer;
//   late Duration _currentTimeRemaining;

//   @override
//   void initState() {
//     super.initState();
//     _calculateNextPrayer();
//     _startTimer();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_currentTimeRemaining.inSeconds > 0) {
//           _currentTimeRemaining -= const Duration(seconds: 1);
//         } else {
//           _calculateNextPrayer();
//         }
//       });
//     });
//   }

//   Future<Map<String, dynamic>> _calculateNextPrayer() async {
//     // Coordinates for the location
//     double latitude = 30.033333;
//     double longitude = 31.233334;

//     DateTime now = DateTime.now();

//     // Getting the prayer times for the current date
//     PrayerTimes prayerTimes = PrayerTimes(
//       coordinates: Coordinates(latitude, longitude),
//       calculationParameters: PrayerCalculationMethod.karachi(),
//       dateTime: now,
//       precision: true,
//       locationName: 'Africa/Cairo',
//     );

//     // Convert prayer times to a map of DateTime objects
//     final prayers = {
//       'Fajr': prayerTimes.fajrStartTime!,
//       'Dhuhr': prayerTimes.dhuhrStartTime!,
//       'Asr': prayerTimes.asrStartTime!,
//       'Maghrib': prayerTimes.maghribStartTime!,
//       'Isha': prayerTimes.ishaStartTime!,
//     };

//     // Find the next prayer time
//     DateTime? nextPrayerTime;
//     String? nextPrayerName;
//     for (var entry in prayers.entries) {
//       if (entry.value.isAfter(now)) {
//         nextPrayerTime = entry.value;
//         nextPrayerName = entry.key;
//         break;
//       }
//     }

//     // If no next prayer time is found, it means the next prayer is Fajr of the next day
//     if (nextPrayerTime == null) {
//       nextPrayerTime = prayers["Fajr"]!.add(const Duration(days: 1));
//       nextPrayerName = "Fajr";
//     }

//     setState(() {
//       nextPrayer = nextPrayerName!;
//       _currentTimeRemaining = nextPrayerTime!.difference(now);
//     });

//     return {
//       'nextPrayerTime': nextPrayerTime,
//       'remainingTime': _currentTimeRemaining,
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: _calculateNextPrayer(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Loading indicator while calculating next prayer
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           // Use the values from the snapshot
//           DateTime nextPrayerTime = snapshot.data!['nextPrayerTime'];
//           Duration remainingTime = snapshot.data!['remainingTime'];
//           return CustomContainerprayer(
//             image: 'assets/images/NextPrayer2.jpg',
//             text: 'Next Prayer',
//             prayerName: nextPrayer,
//             remainingTime: remainingTime,
//             remainingTimeTxt: 'Time Remaining: ${_formatDuration(remainingTime)}',
//             text2: 'Press here to know prayer time',
//           );
//         }
//       },
//     );
//   }

//   String _formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = duration.inMinutes.remainder(60);
//     int seconds = duration.inSeconds.remainder(60);
//     return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
// }









// hagag
class NextPrayerSection extends StatefulWidget {
  const NextPrayerSection({super.key, this.initialDuration});

  final Duration? initialDuration;

  @override
  State<NextPrayerSection> createState() => _NextPrayerSectionState();
}

class _NextPrayerSectionState extends State<NextPrayerSection> {
  final prayers = {
    "Fajr": "04:38",
    "Dhuhr": "12:53",
    "Asr": "16:29",
    "Maghrib": "19:51",
    "Isha": "21:07",

    // "Fajr": "04:38",
    // "Dhuhr": "12:53",
    // "Asr": "16:29",
    // "Maghrib": "19:51",
    // "Isha": "21:08",
  };

  String nextPrayer = '';
  late Timer _timer;
  late Duration _currentTimeRemaining;

  @override
  void initState() {
    super.initState();
    _calculateNextPrayer();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentTimeRemaining.inSeconds > 0) {
          _currentTimeRemaining -= const Duration(seconds: 1);
        } else {
          _calculateNextPrayer();
        }
      });
    });
  }

  void _calculateNextPrayer() {
    DateTime now = DateTime.now().toUtc();

    // Convert prayer times to DateTime objects
    List<MapEntry<String, DateTime>> prayerTimes = prayers.entries.map((entry) {
      DateTime prayerTime = DateFormat("HH:mm").parse(entry.value);
      // Set prayer time to today's date
      return MapEntry(
        entry.key,
        DateTime(
          now.year,
          now.month,
          now.day,
          prayerTime.hour,
          prayerTime.minute,
        ),
      );
    }).toList();

    // Sort prayer times in ascending order
    prayerTimes.sort((a, b) => a.value.compareTo(b.value));

    // Find the next prayer time
    DateTime? nextPrayerTime;
    String? nextPrayerName;
    for (var entry in prayerTimes) {
      if (entry.value.isAfter(now)) {
        nextPrayerTime = entry.value;
        nextPrayerName = entry.key;
        break;
      }
    }

    // If no next prayer time is found, it means the next prayer is Fajr of the next day
    if (nextPrayerTime == null) {
      nextPrayerTime = prayerTimes.first.value.add(const Duration(days: 1));
      nextPrayerName = prayerTimes.first.key;
    }

    setState(() {
      nextPrayer = nextPrayerName!;
      _currentTimeRemaining = nextPrayerTime!.difference(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainerprayer(
      image: 'assets/images/NextPrayer2.jpg',
      text: 'Next Prayer',
      prayerName: nextPrayer,
      remainingTime:_currentTimeRemaining,
      remainingTimeTxt:
          'Time Remaining: ${_formatDuration(_currentTimeRemaining)}',
      text2: 'Press here to know prayer time',
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
