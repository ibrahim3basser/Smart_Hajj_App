import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:hajj_app/auth/login_page.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/helpers/show_user_data.dart';
import 'package:hajj_app/services/prayer_times_service.dart';
import 'package:hajj_app/views/EmergencyPage.dart';
import 'package:hajj_app/views/azkar_page.dart';
import 'package:hajj_app/views/doaa_body.dart';
import 'package:hajj_app/views/home_body.dart';
import 'package:hajj_app/views/map_page.dart';
import 'package:hajj_app/views/mnask_body.dart';
import 'package:hajj_app/views/place_body.dart';
import 'package:hajj_app/views/prayer_time.dart';
import 'package:hajj_app/views/quibla.dart';
import 'package:hajj_app/views/tasbih_page.dart';
import 'package:hajj_app/views/update_user_info.dart';
import 'package:hajj_app/widgets/List_title_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userId});
  static String id = 'HomePage';
  final String userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PrayerTimeService service;
 
  //late String _imageUrl;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  //  _getUserData();
    PrayerTimeService.instance.getPrayersTimes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: currentPageIndex == 2 || currentPageIndex == 3
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(),
                          ),
                        );
                      },
                      child: const Icon(Icons.location_on, color: Colors.brown,)
                    ),
                    const SizedBox(width: 60,),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'قافلة المسلمين',
                        style: TextStyle(color: KTextColor, fontSize: 24),
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: KIconColor,
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/Hajj.png'),
                    ),
                  ],
                ),
                centerTitle: true,
                backgroundColor: KPrimaryColor,
              ),
        endDrawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: KPrimaryColor,
              ),
              child: ShowUserData()
            ),
            ListTileDrawer(
              title: 'الصفحه الشخصيه',
              icon: const Icon(Icons.person, color: KIconColor,),
              onTap: () {
                Navigator.pushNamed(context, UpdateUserProfile.id);
              },
            ),
            ListTileDrawer(
              title: 'مواقيت الصلاه',
              icon: const Icon(FlutterIslamicIcons.kowtow, color: KIconColor,),
              onTap: () {
                Navigator.pushNamed(context, PrayerTimePage.id);
              },
            ),
            ListTileDrawer(
              title: ' اتجاه القبله',
              icon: const Icon(FlutterIslamicIcons.qibla, color: KIconColor,),
              onTap: () {
                Navigator.pushNamed(context, QuiblahPage.id);
              },
            ),
            ListTileDrawer(
              title: 'الاذكار',
              icon: const Icon(FlutterIslamicIcons.hadji, color: KIconColor,),
              onTap: () {
                Navigator.pushNamed(context, AzkarPage.id);
              },
            ),
            ListTileDrawer(
              title: 'المسبحه',
              icon: const Icon(FlutterIslamicIcons.tasbih, color: KIconColor,),
              onTap: () {
                Navigator.pushNamed(context, TasbihPage.id);
              },
            ),
            ListTileDrawer(
              title: 'المساعدة',
              icon: const Icon(Icons.help_center_outlined, color: KIconColor,),
              onTap: () {
                Navigator.pushNamed(context, EmergencyPage.id);
              },
            ),
            ListTileDrawer(
              title: 'تسجيل خروج',
              icon: const Icon(Icons.logout, color: KIconColor,),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginPage.id, (route) => false);
              },
            ),
          ],
        )),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              label: 'الصفحة الرئيسية',
              icon: Icon(Icons.home, color: KIconColor,),
            ),
            NavigationDestination(
              label: 'الادعيه ',
              icon: Icon(FlutterIslamicIcons.takbir, color: KIconColor,),
            ),
            NavigationDestination(
              label: 'المناسك ',
              icon: Icon(FlutterIslamicIcons.kaaba, color: KIconColor,),
            ),
            NavigationDestination(
              label: 'رؤيه الاماكن المقدسه',
              icon: Icon(FlutterIslamicIcons.qibla, color: KIconColor,),
            ),
          ],
        ),
        body: <Widget>[
           const HomeBody(),
          const DoaaBody(),
          const MnaskBody(),
          const PlaceBody(),
        ][currentPageIndex]);
  }
}