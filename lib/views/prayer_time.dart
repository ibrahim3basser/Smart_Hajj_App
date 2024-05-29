import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/views/home_body.dart';
import 'package:hajj_app/widgets/card_for_prayer_time.dart';
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
  Map<String, DateTime>? prayerTimes;
  String? nextPrayer;
  Duration? timeRemaining;
  double? latitude;
  double? longitude;
  String? city;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timeRemaining = widget.timeRemaining;
    nextPrayer = widget.nextPrayer;
    _getLocationAndFetchPrayerTimes();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _getLocationAndFetchPrayerTimes() async {
    await _getLocation();
    _fetchPrayerTimes();
    startTimer();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude!, longitude!);
    setState(() {
      city = placemarks.first.locality;
    });
  }

  DateTime now = DateTime.now();
  void _fetchPrayerTimes() {
    final prayers = PrayerTimes(
      coordinates: Coordinates(30.033333, 31.233334), //(latitude!, longitude!),
      calculationParameters: PrayerCalculationMethod.karachi(),
      locationName: 'Africa/Cairo', //city!,
      dateTime: DateTime.now(),
    );
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    final prayerTimes1 = PrayerTimes(
      coordinates: Coordinates(30.033333, 31.233334), //(latitude!, longitude!),
      calculationParameters: PrayerCalculationMethod.karachi(),
      dateTime: tomorrow,
      precision: true,
      locationName: 'Africa/Cairo',
    );

    setState(() {
      prayerTimes = {
        'Fajr': prayers.fajrStartTime!,
        'Sunrise': prayers.sunrise!,
        'Dhuhr': prayers.dhuhrStartTime!,
        'Asr': prayers.asrStartTime!,
        'Maghrib': prayers.maghribStartTime!,
        'Isha': prayers.ishaStartTime!,
        'Fajr': prayerTimes1.fajrStartTime!,
      };
    });

    _calculateNextPrayer();
  }

  void _calculateNextPrayer() {
    for (var entry in prayerTimes!.entries) {
      DateTime prayerTime = entry.value;
      if (prayerTime.isAfter(now)) {
        setState(() {
          nextPrayer = entry.key;
          timeRemaining = prayerTime.difference(now);
        });
        break;
      } else {}
    }
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (timeRemaining != null) {
        setState(() {
          timeRemaining = timeRemaining! - oneSecond;
        });
        if (timeRemaining!.isNegative) {
          _calculateNextPrayer();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    prayerTimes?.remove("Sunrise");
    prayerTimes?.remove("Sunset");
    prayerTimes?.remove("Imsak");
    prayerTimes?.remove("Midnight");
    prayerTimes?.remove("Firstthird");
    prayerTimes?.remove("Lastthird");

    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Times for $city'),
        centerTitle: true,
        backgroundColor: KPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: prayerTimes == null
            ? const Center(child: CircularProgressIndicator())
            : CardPrayerTime(
                prayerTimes: prayerTimes,
                nextPrayer: nextPrayer,
                timeRemaining: timeRemaining,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeBody(
                  // nextPrayer: nextPrayer,
                  // timeRemaining: timeRemaining,
                  ),
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

//   @override
//   State<PrayerTimePage> createState() => _PrayerTimePageState();
// }

// class _PrayerTimePageState extends State<PrayerTimePage> {

//   static List<String> prayerTimes = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchPrayerTimes();
//   }
  
//   Future<void> fetchPrayerTimes() async {
//     try {
//       final position = await PrayerTimeClass.determinePosition();
//       // final latitude = position.latitude;
//       // final longitude = position.longitude;
//       final latitude = 30.033333;
//       final longitude = 31.233334;
//       const timzone = 3.0;

//       List<String> prtimes = PrayerTimeClass.prayTimeZone(latitude, longitude, timzone);

//       setState(() {
//         prayerTimes = prtimes;
//       });
//     } catch (e) {
//       // Handle error
//       print('Error fetching prayer times: $e');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     if (prayerTimes.isNotEmpty){
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('أوقات الصلاة'),
//         centerTitle: true,
//         backgroundColor: KPrimaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             prayerTimes == null ? Center(child: CircularProgressIndicator())
//               : 
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.asset(
//                   'assets/images/maxresdefault.webp',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             CardPrayerTime(
//               prayerName: 'الفجر',
//               prayerTime: prayerTimes[0],
//               prayerIcon: CupertinoIcons.moon_stars,
//             ),
//             CardPrayerTime(
//               prayerName: 'الظهر',
//               prayerTime: prayerTimes[2],
//               prayerIcon: CupertinoIcons.sun_min,
//             ),
//             CardPrayerTime(
//               prayerName: 'العصر',
//               prayerTime: prayerTimes[3],
//               prayerIcon: CupertinoIcons.sun_haze,
//             ),
//             CardPrayerTime(
//               prayerName: 'المغرب',
//               prayerTime: prayerTimes[5],
//               prayerIcon: CupertinoIcons.sunset,
//             ),
//             CardPrayerTime(
//               prayerName: 'العشاء',
//               prayerTime: prayerTimes[6],
//               prayerIcon: CupertinoIcons.moon,
//             ),
            
//           ],
//         ),
//       ),
//     );
//     }
//   }
  
// }
