import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hajj_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class CardPrayerTime extends StatelessWidget {
  CardPrayerTime({super.key, required this.prayerTimes, required this.nextPrayer, required this.timeRemaining});
  Map<String, String>? prayerTimes;
  String? nextPrayer;
  Duration? timeRemaining;
  List<IconData> prayerIcon = [
    CupertinoIcons.moon_stars,
    CupertinoIcons.sun_min,
    CupertinoIcons.sun_haze,
    CupertinoIcons.sunset,
    CupertinoIcons.moon,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 50,
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/maxresdefault.webp',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Text('الصلاة القادمة: $nextPrayer',
                    style: const TextStyle(color: KTextBrown),
                    textAlign: TextAlign.end,
                  ),
            subtitle: Text(
                'الوقت المتبقي: ${_formatDuration(timeRemaining)}',
                style: const TextStyle(color: KTextBrown),
                textAlign: TextAlign.end,
                ),
          ),
          Card(
            color: Colors.white,
            elevation: 3,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prayerTimes!.length,
              itemBuilder: (BuildContext context, int index) {
                String prayerName = prayerTimes!.keys.toList()[index];
                String prayerTime = _convertTo12HourFormat(prayerTimes![prayerName]!);
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prayerName,
                                  style: const TextStyle(
                                    color: KTextBrown,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  prayerTime,
                                  style: const TextStyle(
                                    color: KTextBrown,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(prayerIcon[index], color: KIconColor, size: 35),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 50,),
        ],
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '';
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _convertTo12HourFormat(String time24) {
    final dateTime = DateFormat.Hm().parse(time24);
    return DateFormat('hh:mm a').format(dateTime);
  }
}
