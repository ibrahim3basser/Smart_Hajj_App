import 'package:flutter/material.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/helpers/read_hajj_json.dart';
import 'package:hajj_app/helpers/read_umrah._json.dart';

class MnaskBody extends StatefulWidget {
  const MnaskBody({super.key});

  @override
  State<MnaskBody> createState() => _MnaskBodyState();
}

class _MnaskBodyState extends State<MnaskBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'المناسك',
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // give the tab bar a height [can change hheight to preferred height]
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: KPrimaryColor,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    // first tab 
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Tab(
                        text: 'مناسك الحج',
                      ),
                    ),

                    // second tab 
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Tab(
                        text: 'مناسك العمره',
                      ),
                    ),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // first tab bar view widget
                    ReadHajjJson(path: "assets/json/hajj.json"),

                    //second tab bar view widget
                    ReadUmrahJson(path: "assets/json/umrah.json")
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
