import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hajj_app/helpers/read_ayat_forhomebody.dart';
import 'package:hajj_app/services/prayer_times_service.dart';
import 'package:hajj_app/views/prayer_time.dart';
import 'package:hajj_app/widgets/container_for_next_prayer_home_body.dart';
import 'package:hajj_app/widgets/container_for_zeham.dart';
import 'package:intl/intl.dart';
import 'package:pray_times/pray_times.dart';

class HomeBody extends StatefulWidget {
  static const String id = 'home_body';
  final String? nextPrayer;
  final Duration? timeRemaining;

  const HomeBody({Key? key, this.nextPrayer, this.timeRemaining})
      : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late Timer _timer;
  late Duration _currentTimeRemaining;
    late PrayerTimeService prayerTimeService;
  
  @override
  void initState() {
    super.initState();
    _startTimer();
    _currentTimeRemaining = widget.timeRemaining ?? Duration.zero;
    prayerTimeService = PrayerTimeService.instance;
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
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/zeham3.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 80, bottom: 25, right: 60),
                      child: Text(
                        'تنبؤات حالات الزحام ',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    CustomContainerForZeham(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 1),
            const ReadAyatForHomeBody(path: 'assets/json/ayat.json'),
            const SizedBox(height: 1),
            CustomContainerprayer(
              image: 'assets/images/NextPrayer2.jpg',
              text: 'Next Prayer',
              prayerName: widget.nextPrayer ?? '',
              remainingTime: 'Time Remaining: ${_formatDuration(_currentTimeRemaining)}',
              text2: 'Press here to know prayer time',
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
}
  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

// FutureBuilder(
//                   future: prayerTimeService.getCurrentPrayerTime(),
//                   builder: (context, snapshot) => CustomContainer(
//                       image: 'assets/images/NextPrayer2.jpg',
//                       text: '~الصلاه القادمهّ~',
//                       // prayerName: 'العصر',
//                       prayerName: snapshot.hasData
//                           ? snapshot.data?.name ?? ""
//                           : "",
//                       remainingTime: 'الوقت المتبقي ${snapshot.data?.timeDifference}',
//                        text2: ' اضغط هنا لمعرفه مواقيت الصلاه'),
//            ),
