import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/views/home_page.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hajj_app/views/home_page.dart';
import 'package:hajj_app/auth/login_page.dart';

class SplashPage extends StatefulWidget {
  static const String id = 'splash_page';

  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    await Future.delayed(
        const Duration(seconds: 4)); // Show splash screen for 3 seconds

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacementNamed(context, LoginPage.id);
    } else {
      Navigator.pushReplacementNamed(context, HomePage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KPrimaryColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 100.0,
            //child: Image.asset('images/Hajj.png'),
            backgroundImage: AssetImage('assets/images/Hajj.png'),
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            'الحج الذكى',
            style: GoogleFonts.lemonada(
                textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
          ),
          const SizedBox(height: 30,),
          const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "وَلِلّهِ عَلَى النَّاسِ حِجُّ الْبَيْتِ مَنِ اسْتَطَاعَ إِلَيْهِ سَبِيلاً. {آل عمران:97}\n{البقرة:196}.وَأَتِمُّوا الْحَجَّ وَالْعُمْرَةَ لِلَّهِ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
        ],
      )),
    );
  }
}
