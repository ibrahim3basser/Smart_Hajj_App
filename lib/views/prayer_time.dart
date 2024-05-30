import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/helpers/permissions/main_permissions_helper.dart';
import 'package:hajj_app/views/home_body.dart';
import 'package:hajj_app/widgets/card_for_prayer_time.dart';
import 'package:intl/intl.dart';
import 'package:prayers_times/prayers_times.dart';

class PrayerTimePage extends StatefulWidget {
  static String id = 'PrayerTimePage';
  final String? nextPrayer;
  final Duration? timeRemaining;

  const PrayerTimePage({super.key, this.nextPrayer, this.timeRemaining});

  @override
  State<PrayerTimePage> createState() => _PrayerTimePageState();
}

class _PrayerTimePageState extends State<PrayerTimePage> {
  final  prayers = {
        "Fajr": "04:38",
        "Dhuhr": "12:53",
        "Asr": "16:29",
        "Maghrib": "19:51",
        "Isha": "21:07",
        "Fajr": "04:38",
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
List<MapEntry<String, DateTime>>? prayerTimes ;
  void _calculateNextPrayer() {
    DateTime now = DateTime.now().toUtc();

    // Convert prayer times to DateTime objects
    prayerTimes = prayers.entries.map((entry) {
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
    prayerTimes!.sort((a, b) => a.value.compareTo(b.value));

    // Find the next prayer time
    DateTime? nextPrayerTime;
    String? nextPrayerName;
    for (var entry in prayerTimes!) {
      if (entry.value.isAfter(now)) {
        nextPrayerTime = entry.value;
        nextPrayerName = entry.key;
        break;
      }
    }

    // If no next prayer time is found, it means the next prayer is Fajr of the next day
    if (nextPrayerTime == null) {
      nextPrayerTime = prayerTimes!.first.value.add(const Duration(days: 1));
      nextPrayerName = prayerTimes!.first.key;
    }

    setState(() {
      nextPrayer = nextPrayerName!;
      _currentTimeRemaining = nextPrayerTime!.difference(now);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        centerTitle: true,
        backgroundColor: KPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: prayers == null
            ? Container(
                alignment: Alignment.center,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: const CircularProgressIndicator(),
              )
            : CardPrayerTime(
                prayerTimes: prayers,
                nextPrayer: nextPrayer,
                timeRemaining: _currentTimeRemaining,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeBody(),
            ),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}





// class PrayerTimePage extends StatefulWidget {
//   static String id = 'PrayerTimePage';
//   final String? nextPrayer;
//   final Duration? timeRemaining;

//   const PrayerTimePage({super.key, this.nextPrayer, this.timeRemaining});

//   @override
//   State<PrayerTimePage> createState() => _PrayerTimePageState();
// }

// class _PrayerTimePageState extends State<PrayerTimePage> {
//   Map<String, DateTime>? prayerTimes;
//   String? nextPrayer;
//   Duration? timeRemaining;
//   double? latitude;
//   double? longitude;
//   String? city;
//   String? continent;
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     timeRemaining = widget.timeRemaining;
//     nextPrayer = widget.nextPrayer;
//     _getLocationAndFetchPrayerTimes();
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   Future<void> _getLocationAndFetchPrayerTimes() async {
//     await _getLocation();
//     _fetchPrayerTimes();
//     startTimer();
//   }

//   Future<void> _getLocation() async {
//     Position position = await MainPermissionHandler.requestLocationPermission();
//     setState(() {
//       // latitude = position.latitude;
//       // longitude = position.longitude;
//       latitude = 30.033333; 
//       longitude = 31.233334;
//     });

//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude!, longitude!);

//     if (placemarks.isNotEmpty) {
//       setState(() {
//         city = placemarks.first.locality;
//         continent = placemarks.first.isoCountryCode;
//       });
//     }
//   }

//   DateTime now = DateTime.now();
//   void _fetchPrayerTimes() {
//     if (latitude == null || longitude == null || city == null || continent == null) {
//       return;
//     }

//     final locationName = '$continent/$city';

//     final prayers = PrayerTimes(
//       coordinates: Coordinates(latitude!, longitude!),
//       calculationParameters: PrayerCalculationMethod.karachi(),
//       dateTime: DateTime.now(),
//       precision: true,
//       locationName: 'Africa/Cairo' ,  //locationName,
//     );

//     setState(() {
//       prayerTimes = {
//         'Fajr': prayers.fajrStartTime!,
//         'Dhuhr': prayers.dhuhrStartTime!,
//         'Asr': prayers.asrStartTime!,
//         'Maghrib': prayers.maghribStartTime!,
//         'Isha': prayers.ishaStartTime!,
//       };
//     });

//     _calculateNextPrayer();
//   }

//   void _calculateNextPrayer() {
//     DateTime now = DateTime.now();

//     for (var entry in prayerTimes!.entries) {
//       DateTime prayerTime = entry.value;
//       if (prayerTime.isAfter(now)) {
//         setState(() {
//           nextPrayer = entry.key;
//           timeRemaining = prayerTime.difference(now);
//         });
//         break;
//       }
//     }

//     // If no next prayer is found for today, set Fajr of the next day
//     if (nextPrayer == null || timeRemaining == null) {
//       final prayersTomorrow = PrayerTimes(
//         coordinates: Coordinates(latitude!, longitude!),
//         calculationParameters: PrayerCalculationMethod.karachi(),
//         dateTime: DateTime(now.year, now.month, now.day + 1),
//         precision: true,
//         locationName:  'Africa/Cairo' , //'$continent/$city',
//       );

//       setState(() {
//         nextPrayer = 'Fajr';
//         timeRemaining = prayersTomorrow.fajrStartTime!.difference(now);
//       });
//     }
//   }

//   void startTimer() {
//     const oneSecond = Duration(seconds: 1);
//     timer = Timer.periodic(oneSecond, (timer) {
//       if (timeRemaining != null) {
//         setState(() {
//           timeRemaining = timeRemaining! - oneSecond;
//         });
//         if (timeRemaining!.isNegative) {
//           _calculateNextPrayer();
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Prayer Times for ${city ?? ""}'),
//         centerTitle: true,
//         backgroundColor: KPrimaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: prayerTimes == null
//             ? Container(
//                 alignment: Alignment.center,
//                 width: MediaQuery.sizeOf(context).width,
//                 height: MediaQuery.sizeOf(context).height,
//                 child: const CircularProgressIndicator(),
//               )
//             : CardPrayerTime(
//                 prayerTimes: prayerTimes,
//                 nextPrayer: nextPrayer,
//                 timeRemaining: timeRemaining,
//               ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const HomeBody(),
//             ),
//           );
//         },
//         child: const Icon(Icons.arrow_forward),
//       ),
//     );
//   }
// }
