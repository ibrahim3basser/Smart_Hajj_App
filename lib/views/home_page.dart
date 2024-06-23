import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hajj_app/auth/login_page.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/helpers/show_user_data_in_homep.dart';
import 'package:hajj_app/views/EmergencyPage.dart';
import 'package:hajj_app/views/azkar_page.dart';
import 'package:hajj_app/views/doaa_body.dart';
import 'package:hajj_app/views/google_map_view.dart';
import 'package:hajj_app/views/home_body.dart';
import 'package:hajj_app/views/mnask_body.dart';
import 'package:hajj_app/views/place_body.dart';
import 'package:hajj_app/views/prayer_time.dart';
import 'package:hajj_app/views/quibla.dart';
import 'package:hajj_app/views/tasbih_page.dart';
import 'package:hajj_app/views/update_user_info.dart';
import 'package:hajj_app/widgets/List_title_drawer.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userId});
  static String id = 'HomePage';
  final String userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: currentPageIndex == 2 || currentPageIndex == 3
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>const  GoogleMapView(),
                            ),
                          );
                         // Navigator.pushNamed(context, GoogleMapView.id);
                        },
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 90,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'الحج الذكي',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/Hajj.png'),
                    ),
                  ],
                ),
                centerTitle: true,
                backgroundColor: KPrimaryColor,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
        endDrawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: KPrimaryColor,
                ),
                child: ShowUserData()),
            ListTileDrawer(
              title: 'الصفحه الشخصيه',
              icon: const Icon(Icons.person),
              onTap: () {
                Navigator.pushNamed(context, UpdateUserProfile.id);
              },
            ),
            ListTileDrawer(
              title: 'مواقيت الصلاه',
              icon: const Icon(FlutterIslamicIcons.kowtow),
              onTap: () {
                Navigator.pushNamed(context, PrayerTimePage.id);
              },
            ),
            ListTileDrawer(
              title: ' اتجاه القبله',
              icon: const Icon(FlutterIslamicIcons.qibla),
              onTap: () {
                Navigator.pushNamed(context, QuiblahPage.id);
              },
            ),
            ListTileDrawer(
              title: 'الاذكار',
              icon: const Icon(FlutterIslamicIcons.hadji),
              onTap: () {
                Navigator.pushNamed(context, AzkarPage.id);
              },
            ),
            ListTileDrawer(
              title: 'المسبحه',
              icon: const Icon(FlutterIslamicIcons.tasbih),
              onTap: () {
                Navigator.pushNamed(context, TasbihPage.id);
              },
            ),
            ListTileDrawer(
              title: 'المساعدة',
              icon: const Icon(Icons.help_center_outlined),
              onTap: () {
                Navigator.pushNamed(context, EmergencyPage.id);
              },
            ),
            ListTileDrawer(
              title: 'تسجيل خروج',
              icon: const Icon(Icons.logout),
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
          indicatorColor: Colors.blueGrey,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              label: 'الصفحة الرئيسية',
              icon: Icon(Icons.home),
            ),
            NavigationDestination(
              label: 'الادعيه ',
              icon: Icon(FlutterIslamicIcons.takbir),
            ),
            NavigationDestination(
              label: 'المناسك ',
              icon: Icon(FlutterIslamicIcons.kaaba),
            ),
            NavigationDestination(
              label: 'رؤيه الاماكن المقدسه',
              icon: Icon(FlutterIslamicIcons.qibla),
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
