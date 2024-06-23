import 'package:flutter/material.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/services/video_player_360.dart';
import 'package:hajj_app/widgets/container_for_360.dart';
import 'package:video_360/video_360.dart';

class PlaceBody extends StatefulWidget {
  const PlaceBody({Key? key});

  @override
  _PlaceBodyState createState() => _PlaceBodyState();
}

class _PlaceBodyState extends State<PlaceBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الأماكن المقدسة',
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container360(
                backgroundImage: const AssetImage('assets/images/OIP.jpeg'),
                text: 'الكعبة',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => View360(
                        path: 'https://drive.google.com/uc?export=download&id=1ZKLQI9KZ-4aVfoEkr3-HhOMS9H73T9z0',
                        
                      ),
                    ),
                  );
                },
              ),
              Container360(
                backgroundImage: const AssetImage('assets/images/photo_2024-05-01_20-09-21 (2).jpg'),
                text: 'المسجد النبوي',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => View360(
                        path: 'https://drive.google.com/uc?export=download&id=13CO9wDJurAQtWNOZgEt6eT8Zi-KMmbIS',
                      ),
                    ),
                  );
                },
              ),
              Container360(
                backgroundImage: const AssetImage('assets/images/madina.jpeg'),
                text: 'المدينه المنورة',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => View360(
                        path: 'https://drive.google.com/uc?export=download&id=1rTPW3dNcoR2GYYIyEVTcaBPcnUQNqB7d',
                      ),
                    ),
                  );
                },
              ),
              Container360(
                backgroundImage: const AssetImage('assets/images/arafaa.jpg'),
                text: 'جبل عرفة',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => View360(
                        path: 'https://drive.google.com/uc?export=download&id=1tKL8fXvDW06HCzC0oI8URZUKLyaLlDPC',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
