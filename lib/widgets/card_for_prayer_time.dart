import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class CardPrayerTime extends StatelessWidget {
  CardPrayerTime({super.key,required this.prayerTimes, required this.nextPrayer, required this.timeRemaining});
  Map<String, DateTime>? prayerTimes;
  String? nextPrayer;
  Duration? timeRemaining;
  List<IconData> prayerIcon = [
                  CupertinoIcons.moon_stars,
                  CupertinoIcons.sun_min,
                  CupertinoIcons.sun_haze,
                  CupertinoIcons.sunset,
                  CupertinoIcons.moon ];

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
              offset: Offset(1, 1),
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
                    title: Text('Next Prayer: $nextPrayer'),
                    subtitle: Text(
                        'Time Remaining: ${_formatDuration(timeRemaining)}'),
                  ),
                    Card(
                      color: Colors.white,
                      elevation: 3,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: prayerTimes!.length,
                        itemBuilder: (BuildContext context, int index) {
                          String prayerName = prayerTimes!.keys.toList()[index];
                          String prayerTime = DateFormat('h:mm a').format(prayerTimes![prayerName]!);
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
                                        padding: const EdgeInsets.only(left:20.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              prayerName,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              prayerTime,
                                              style: TextStyle(
                                                color: Colors.grey[850],
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(prayerIcon[index], color: Colors.orange, size: 35),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          
                          
                          // ListTile(
                          //   title: Padding(
                          //     padding: const EdgeInsets.only(right: 8.0),
                          //     child: Text(prayerName,style: TextStyle(fontSize: 20,),),
                          //   ),
                          //   subtitle: Padding(
                          //     padding: const EdgeInsets.only(right: 8.0),
                          //     child: Text(prayerTime.replaceRange(5, 11, ''),
                          //       style: TextStyle(fontSize: 20,),),
                          //   ),
                          //   trailing: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Icon(prayerIcon[index], color: Colors.orange, size: 35),
                          //   ), 
                          // );
                        },
                      ),
                    ),
                    const SizedBox(height: 50,),
                  ],
                )
            );
  }
  String _formatDuration(Duration? duration) {
    if (duration == null) return '';
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}