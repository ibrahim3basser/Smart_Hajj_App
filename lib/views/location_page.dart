import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hajj_app/views/home_body.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:prayers_times/prayers_times.dart';


class LocationPage extends StatefulWidget {
  static String id = 'LocationPage';
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
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
      coordinates: Coordinates(30.033333,31.233334),              //(latitude!, longitude!),
      calculationParameters: PrayerCalculationMethod.karachi(),
      locationName: 'Africa/Cairo',     //city!,
      dateTime: DateTime.now(),
    );
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    final prayerTimes1 = PrayerTimes(
      coordinates: Coordinates(30.033333,31.233334),              //(latitude!, longitude!),
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
      }
      else{

      }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Times'),
      ),
      body: prayerTimes == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Next Prayer: $nextPrayer'),
                    subtitle: Text(
                        'Time Remaining: ${_formatDuration(timeRemaining)}'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: prayerTimes!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String prayerName =
                          prayerTimes!.keys.toList()[index];
                      String prayerTime = DateFormat('h:mm a')
                          .format(prayerTimes![prayerName]!);
                      return ListTile(
                        title: Text(prayerName),
                        subtitle: Text(prayerTime),
                      );
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeBody(
                // nextPrayer: nextPrayer,
                // timeRemaining: timeRemaining,
              ),
            ),
          );
        },
        child: Icon(Icons.arrow_forward),
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
}




  
  
  
  
  
  
  
//   Map<String, DateTime>? prayerTimes;
//   String? nextPrayer;
//   Duration? timeRemaining;
//   double? latitude;
//   double? longitude;
//   String? city;
//   double? timezone; 

//   @override
//   void initState() {
//     super.initState();
//     _fetchPrayerTimes();
//     startTimer();
//     _getLocation();
    
//   }

//   Future<void> _getLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     setState(() {
//       latitude = position.latitude;
//       longitude = position.longitude;
//     });

//     List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);
//     setState(() {
//       city = placemarks.first.locality;
//     });
//   }


//   Future<void> _fetchPrayerTimes() async {

//     final String apiUrl =
//         'http://api.aladhan.com/v1/calendar/${DateTime.now().year}/${DateTime.now().month}?latitude=$latitude&longitude=$longitude&method=2';

//     final response = await http.get(Uri.parse(apiUrl));
//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//           Map<String, dynamic> params = data['data'][0]['meta'];
//           setState(() {
//             timezone = params['timezone'];
//           });
//         } else {
//           throw Exception('Failed to fetch prayer times');
//         }
      

//     PrayerTimes prayers = PrayerTimes();

//     prayers.setTimeFormat(prayers.Time12);
//     prayers.setCalcMethod(prayers.MWL);
//     prayers.setAsrJuristic(prayers.Shafii);
//     prayers.setAdjustHighLats(prayers.AngleBased);
//     var offsets = [0, 0, 0, 0, 0, 0, 0];
//     prayers.tune(offsets);

//     final date = DateTime.now();
//     prayerTimes = {};
//     List<String> prayerTimesList =
//         prayers.getPrayerTimes(date, latitude!, longitude!, timezone!);
//     List<String> prayerNames = prayers.getTimeNames();

//     for (int i = 0; i < prayerNames.length; i++) {
//       prayerTimes![prayerNames[i]] = DateFormat('HH:mm').parse(prayerTimesList[i]);
//     }

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
//   }

//   void startTimer() {
//     const oneSecond = Duration(seconds: 1);
//     Timer.periodic(oneSecond, (timer) {
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
//         title: Text('Prayer Times'),
//       ),
//       body: prayerTimes == null
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Text('Next Prayer: $nextPrayer'),
//                     subtitle: Text('Time Remaining: ${_formatDuration(timeRemaining)}'),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: prayerTimes!.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       String prayerName = prayerTimes!.keys.toList()[index];
//                       String prayerTime = DateFormat('HH:mm').format(prayerTimes![prayerName]!);
//                       return ListTile(
//                         title: Text(prayerName),
//                         subtitle: Text(prayerTime),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   String _formatDuration(Duration? duration) {
//     if (duration == null) return '';
//     int hours = duration.inHours;
//     int minutes = duration.inMinutes.remainder(60);
//     int seconds = duration.inSeconds.remainder(60);
//     return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
// }


             



  
  
  
//   Map<String, dynamic>? prayerTimes;
//   double? latitude;
//   double? longitude;
//   String? city;
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     _getLocationAndFetchPrayerTimes();

//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   Future<void> _getLocationAndFetchPrayerTimes() async {
//     await _getLocation();
//     await _fetchPrayerTimes();
//   }

//   Future<void> _getLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     setState(() {
//       latitude = position.latitude;
//       longitude = position.longitude;
//     });

//     List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);
//     setState(() {
//       city = placemarks.first.locality;
//     });
//   }

//   Future<void> _fetchPrayerTimes() async {
//     final String apiUrl =
//         'http://api.aladhan.com/v1/calendar/${DateTime.now().year}/${DateTime.now().month}?latitude=$latitude&longitude=$longitude&method=2';

//     final response = await http.get(Uri.parse(apiUrl));
//     if (response.statusCode == 200) {
//       setState(() {
//         prayerTimes = json.decode(response.body)['data'][DateTime.now().day]['timings'];
//       });
//     } else {
//       throw Exception('Failed to load prayer times');
//     }
//   }


//   String _calculateNextPrayer() {
//   if (prayerTimes == null) return '';

//   DateTime now = DateTime.now();
//   print(prayerTimes);
//   List<String> prayerNames = prayerTimes!.keys.toList();
//   for (int i = 0; i < prayerNames.length; i++) {
//     String prayerName = prayerNames[i];
//     String prayerTimeString = prayerTimes![prayerName]!;
//     String timePortion = prayerTimeString.replaceRange(5, 11, ''); // Extract time portion
//     DateTime prayerTime = DateFormat.Hm().parse(timePortion);
//     print(prayerTime);
//     // Convert prayer time to 12-hour format
//     String formattedPrayerTime = DateFormat('h:mm a').format(prayerTime);
//     if (now.isBefore(prayerTime)) {
//       Duration difference = prayerTime.difference(now);
//       return 'Next Prayer: $prayerName at $formattedPrayerTime (in ${difference.inHours}h ${difference.inMinutes.remainder(60)}m ${difference.inSeconds.remainder(60)}s)';
//     }
//   }
//   return 'No upcoming prayers';
// }


//   @override
// Widget build(BuildContext context) {
//     prayerTimes?.remove("Sunrise");
//     prayerTimes?.remove("Sunset");
//     prayerTimes?.remove("Imsak");
//     prayerTimes?.remove("Midnight");
//     prayerTimes?.remove("Firstthird");
//     prayerTimes?.remove("Lastthird");
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Prayer Times for $city'),
//     ),
//     body: prayerTimes == null
//         ? Center(child: CircularProgressIndicator())
//         : SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.6, // Set the height to 60% of the screen height
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: prayerTimes!.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       String prayerName = prayerTimes!.keys.toList()[index];
//                       String prayerTime = prayerTimes!.values.toList()[index];
//                       return ListTile(
//                         title: Text(prayerName),
//                         subtitle: Text(prayerTime),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   _calculateNextPrayer(),
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ],
//             ),
//           ),
//   );
// }

// }
  









// ------------------------------- get lat and long ---------------------------
// class LocationPage extends StatefulWidget {
//   static String id = 'LocationPage';
//   @override
//   _LocationPageState createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   String? cityName;
//   double? latitude;
//   double? longitude;
//   final String apiUrl = 'http://api.aladhan.com/v1/calendar';
//   Map<String, dynamic> prayerTimes = {};

//   @override
//   void initState() {
//     super.initState();
//     getLocation();
//   }

//   Future<void> getLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       setState(() {
//         latitude = position.latitude;
//         longitude = position.longitude;
//         cityName = placemarks.first.locality;
//       });
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Latitude: ${latitude ?? "Loading..."}',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Longitude: ${longitude ?? "Loading..."}',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'City: ${cityName ?? "Loading..."}',
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// -------------------------------- prayer time and name -------------------------
// class LocationPage extends StatefulWidget {
//     static String id = 'LocationPage';
//   @override
//   State<LocationPage> createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   final String apiUrl = 'http://api.aladhan.com/v1/calendar';
//   Map<String, dynamic> prayerTimes = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchPrayerTimes();
//   }

//   Future<void> fetchPrayerTimes() async {
//     final latitude = 40.7128; // Replace with your latitude
//     final longitude = -74.0060; // Replace with your longitude
//     final year = DateTime.now().year;
//     final month = DateTime.now().month;

//     final response = await http.get(Uri.parse('$apiUrl/$year/$month?latitude=$latitude&longitude=$longitude&method=2'));

//     if (response.statusCode == 200) {
//       setState(() {
//         prayerTimes = json.decode(response.body)['data'][0]['timings'];
//       });
//     } else {
//       throw Exception('Failed to load prayer times: ${response.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Prayer Times'),
//       ),
//       body: prayerTimes.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: prayerTimes.length,
//               itemBuilder: (BuildContext context, int index) {
//                 String prayerName = prayerTimes.keys.toList()[index];
//                 String prayerTime = prayerTimes.values.toList()[index];
//                 return ListTile(
//                   title: Text(prayerName),
//                   subtitle: Text(prayerTime),
//                 );
//               },
//             ),
//     );
//   }
// }


//   --------------------- timer for zeham ----------------------------------
// import 'dart:async';
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';


// class LocationPage extends StatefulWidget {
//   LocationPage({super.key});
//   static String id = 'LocationPage';
  

//   @override
//   State<LocationPage> createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {

//   DateTime prayerTime = DateTime.now().add(const Duration(hours: 1)); // Replace this with your prayer time
//   late Timer timer;
//   late Duration remainingTime;

//   @override
//   void initState() {
//     super.initState();
//     calculateTimeRemaining();
//     startTimer();
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   void calculateTimeRemaining() {
//     remainingTime = prayerTime.difference(DateTime.now());
//     if (remainingTime.isNegative) {
//       // If the prayer time has already passed, set remaining time to 0
//       remainingTime = Duration.zero;
//     }
//   }

//   void startTimer() {
//     timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       setState(() {
//         calculateTimeRemaining();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     String formattedRemainingTime = DateFormat.Hms().format(DateTime(0, 0, 0, remainingTime.inHours, remainingTime.inMinutes.remainder(60), remainingTime.inSeconds.remainder(60)));

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Prayer Time'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Time Remaining for Prayer:',
//               style: TextStyle(fontSize: 20),
//             ),
//             Text(
//               formattedRemainingTime,
//               style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
