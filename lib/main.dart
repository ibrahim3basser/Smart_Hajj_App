import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hajj_app/firebase_options.dart';
import 'package:hajj_app/helpers/read_doaa_json.dart';
import 'package:hajj_app/views/EmergencyPage.dart';
import 'package:hajj_app/views/azkar_page.dart';
import 'package:hajj_app/views/forget_password_page.dart';
import 'package:hajj_app/views/google_map_view.dart';
import 'package:hajj_app/views/home_page.dart';
import 'package:hajj_app/auth/login_page.dart';
import 'package:hajj_app/views/prayer_time.dart';
import 'package:hajj_app/views/quibla.dart';
import 'package:hajj_app/auth/register_page.dart';
import 'package:hajj_app/views/tasbih_page.dart';
import 'package:hajj_app/views/update_user_info.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hajj_app/firebase_options.dart';
import 'package:hajj_app/helpers/read_doaa_json.dart';
import 'package:hajj_app/views/EmergencyPage.dart';
import 'package:hajj_app/views/azkar_page.dart';
import 'package:hajj_app/views/forget_password_page.dart';
import 'package:hajj_app/views/google_map_view.dart';
import 'package:hajj_app/views/home_page.dart';
import 'package:hajj_app/auth/login_page.dart';
import 'package:hajj_app/views/prayer_time.dart';
import 'package:hajj_app/views/quibla.dart';
import 'package:hajj_app/auth/register_page.dart';
import 'package:hajj_app/views/tasbih_page.dart';
import 'package:hajj_app/views/update_user_info.dart';
import 'package:hajj_app/views/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Hajj());
}

class Hajj extends StatelessWidget {
  const Hajj({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        SplashPage.id: (context) => const SplashPage(),
        LoginPage.id: (context) => const LoginPage(),
        Register.id: (context) => const Register(),
        HomePage.id: (context) => HomePage(userId: FirebaseAuth.instance.currentUser?.uid ?? ''),
        QuiblahPage.id: (context) => const QuiblahPage(),
        AzkarPage.id: (context) => const AzkarPage(),
        PrayerTimePage.id: (context) => const PrayerTimePage(),
        ReadDoaaJson.id: (context) => ReadDoaaJson(path: 'assets/json/doaa.json'),
        TasbihPage.id: (context) => const TasbihPage(),
        EmergencyPage.id: (context) => const EmergencyPage(),
        GoogleMapView.id: (context) => const GoogleMapView(),
        UpdateUserProfile.id: (context) => const UpdateUserProfile(),
        ResetPasswordPage.id: (context) =>  const ResetPasswordPage(),
      },
      initialRoute: SplashPage.id,
    );
  }
}







// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const Hajj());
// }

// class Hajj extends StatelessWidget {
//   const Hajj({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       routes: {
//         LoginPage.id: (context) => const LoginPage(),
//         Register.id: (context) => const Register(),
//         HomePage.id: (context) => HomePage(userId: FirebaseAuth.instance.currentUser!.uid),
//         QuiblahPage.id: (context) => const QuiblahPage(),
//         AzkarPage.id: (context) => const AzkarPage(),
//         PrayerTimePage.id: (context) => const PrayerTimePage(),
//         ReadDoaaJson.id: (context) => ReadDoaaJson(path: 'assets/json/doaa.json'),
//         TasbihPage.id: (context) => const TasbihPage(),
//         EmergencyPage.id: (context) => const EmergencyPage(),
//         GoogleMapView.id: (context) => const GoogleMapView(),
//         UpdateUserProfile.id: (context) => const UpdateUserProfile(),
//         ResetPasswordPage.id: (context) =>  const ResetPasswordPage(),
//         //userId: FirebaseAuth.instance.currentUser!.uid
//       },
//       initialRoute: FirebaseAuth.instance.currentUser==null? LoginPage.id : HomePage.id,
//       //initialRoute: GoogleMapView.id,
//     );
//   }
// }
