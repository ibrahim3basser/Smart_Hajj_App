import 'package:flutter/material.dart';
import 'package:hajj_app/helpers/read_ayat_forhomebody.dart';
import 'package:hajj_app/services/prayer_times_service.dart';
import 'package:hajj_app/widgets/container_for_zeham.dart';
import 'package:hajj_app/widgets/home_body/next_prayer_section.dart';


class HomeBody extends StatefulWidget {
  static const String id = 'home_body';
  final String? nextPrayer;
  final Duration? timeRemaining;

  const HomeBody({super.key, this.nextPrayer, this.timeRemaining});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late PrayerTimeService prayerTimeService;

  @override
  void initState() {
    super.initState();
    prayerTimeService = PrayerTimeService.instance;
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 80, bottom: 25, right: 60),
                      child: Text(
                        'تنبؤات حالات الزحام ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
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
            NextPrayerSection(
              initialDuration: widget.timeRemaining,
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
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
