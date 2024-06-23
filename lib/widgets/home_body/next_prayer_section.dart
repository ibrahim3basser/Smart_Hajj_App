import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../container_for_next_prayer_home_body.dart'; // Ensure to add intl package to pubspec.yaml
import 'package:http/http.dart' as http;

class NextPrayerSection extends StatefulWidget {
  const NextPrayerSection({super.key, this.initialDuration});

  final Duration? initialDuration;

  @override
  State<NextPrayerSection> createState() => _NextPrayerSectionState();
}

class _NextPrayerSectionState extends State<NextPrayerSection> {
  final prayers = {
    "الفجر": "04:09",
    "الظهر": "12:58",
    "العصر": "16:33",
    "المغرب": "20:00",
    "العشاء": "21:34",
    "الفجر": "04:09",
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
      text: 'الصلاه القادمه  ',
      prayerName: nextPrayer,
      remainingTime: _currentTimeRemaining,
      remainingTimeTxt:
          'Time Remaining: ${_formatDuration(_currentTimeRemaining)}',
      text2: 'اضغط هنا لمعرفه مواقيت الصلاه',
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
