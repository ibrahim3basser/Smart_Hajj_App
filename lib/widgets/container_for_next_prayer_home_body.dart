import 'package:flutter/material.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/views/prayer_time.dart';

// class CustomContainer extends StatelessWidget {
//   final String image;
//   final String text;
//   final String prayerName;
//   final String remainingTime;
//   final String text2;

//   @override
//   const CustomContainer(
//       {super.key,
//       required this.image,
//       required this.text,
//       required this.prayerName,
//       required this.remainingTime,
//       required this.text2});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, PrayerTimePage.id);
//       },
//       child: Container(
//         width: MediaQuery.of(context)
//             .size
//             .width, // Set container width to match the screen width
//         height: MediaQuery.of(context).size.height * 0.3,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(image),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 text,
//                 style: const TextStyle(
//                     fontSize: 24,
//                     color: Color.fromARGB(255, 122, 122, 53),
//                     fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 prayerName,
//                 style: const TextStyle(
//                     fontSize: 24,
//                     color: Color.fromARGB(255, 122, 122, 53),
//                     fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 remainingTime,
//                 style: const TextStyle(
//                     fontSize: 18,
//                     color: Color.fromARGB(255, 122, 122, 53),
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 text2,
//                 style: const TextStyle(
//                     fontSize: 14, color: Color.fromARGB(255, 122, 122, 53)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomContainerprayer extends StatelessWidget {
  CustomContainerprayer(
      {super.key,
      required this.image,
      required this.text,
      required this.prayerName,
      required this.remainingTime,
      required this.text2,
      required this.remainingTimeTxt});
  String image;
  String text;
  String prayerName;
  Duration remainingTime;
  String text2;
  final String remainingTimeTxt;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrayerTimePage(
              nextPrayer: prayerName,
              timeRemaining: remainingTime,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                    fontSize: 24,
                    color: KTextColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                prayerName,
                style: const TextStyle(
                    fontSize: 24,
                    color: KTextColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                _formatDuration(remainingTime),
                style: const TextStyle(
                    fontSize: 18,
                    color: KTextColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                text2,
                style: const TextStyle(
                    fontSize: 14, color: KTextColor),
              ),
            ],
          ),
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
