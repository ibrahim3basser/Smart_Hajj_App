import 'package:flutter/material.dart';
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
                        path: 'https://drive.google.com/uc?export=download&id=1ygAlbkwVTGD6BpvUGbOhKpKa4f1lupXr',
                        
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
                        path: 'https://drive.google.com/uc?export=download&id=1FylAnE84GRu8WNM0gKO_wQOJsgVOK6Fu',
                      ),
                    ),
                  );
                },
              ),
              Container360(
                backgroundImage: const AssetImage('assets/images/ph.jpg'),
                text: 'منى',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => View360(
                        path: 'https://drive.google.com/file/d/1upvVpAYkXBfCL-sonUV2vpqbHVrgQXEw/view?usp=sharing',
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
                        path: 'https://drive.google.com/uc?export=download&id=1I75m73myN_oKf9G8rQhLIZMd2UdcTKIb',
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
