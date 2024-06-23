// import 'package:flutter/material.dart';
// import 'package:hajj_app/constants.dart';
// import 'package:hajj_app/helpers/readazkarjson.dart';

// class AzkarPage extends StatefulWidget {
//   static String id = 'AzkarPage';

//   const AzkarPage({super.key});
//   @override
//   // ignore: library_private_types_in_public_api
//   _AzkarPageState createState() => _AzkarPageState();
// }

// class _AzkarPageState extends State<AzkarPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;


//   @override
//   void initState() {
//     _tabController = TabController(length: 3, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'الاذكار',
//           ),
//           centerTitle: true,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               // give the tab bar a height [can change hheight to preferred height]
//               Container(
//                 height: 45,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(
//                     25.0,
//                   ),
//                 ),
//                 child: TabBar(
//                   controller: _tabController,
//                   // give the indicator a decoration (color and border radius)
//                   indicator: BoxDecoration(
//                     borderRadius: BorderRadius.circular(
//                       25.0,
//                     ),
//                     color: KPrimaryColor,
//                   ),
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.black,
//                   tabs: const [
//                     // first tab [you can add an icon using the icon property]
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Tab(
//                         text: 'اذكار الصباح',
//                       ),
//                     ),

//                     // second tab [you can add an icon using the icon property]
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Tab(
//                         text: 'اذكار المساء',
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Tab(
//                         text: 'اذكار بعد الصلاه',
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               // tab bar view here
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     // first tab bar view widget
//                     ReadAzkarJson(
//                       path: 'assets/json/azkar_sabah.json',
//                     ),

//                     //second tab bar view widget
//                     ReadAzkarJson(
//                       path: 'assets/json/azkar_massa.json',
                      
//                     ),
//                     // third tab bar view widget
//                     ReadAzkarJson(
//                       path: 'assets/json/PostPrayer_azkar.json',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/models/azkar_model.dart';

class AzkarPage extends StatefulWidget {
  static String id = 'AzkarPage';

  const AzkarPage({super.key});
  @override
  _AzkarPageState createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('الاذكار',style:  TextStyle(color: KTextColor),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: KPrimaryColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Tab(text: 'اذكار الصباح'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Tab(text: 'اذكار المساء'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Tab(text: 'اذكار بعد الصلاه'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ReadAzkarJson(path: 'assets/json/azkar_sabah.json'),
                  ReadAzkarJson(path: 'assets/json/azkar_massa.json'),
                  ReadAzkarJson(path: 'assets/json/PostPrayer_azkar.json'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadAzkarJson extends StatefulWidget {
  const ReadAzkarJson({super.key, required this.path});
  final String path;

  @override
  State<ReadAzkarJson> createState() => _ReadAzkarJsonState();
}

class _ReadAzkarJsonState extends State<ReadAzkarJson> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readJson(widget.path),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<AzkarModel> azkar = snapshot.data as List<AzkarModel>;
          return ListView.builder(
            itemCount: azkar.length,
            itemBuilder: (context, index) {
              return AzkarItem(azkar: azkar[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<AzkarModel>> readJson(String fileName) async {
    try {
      final jsonData = await rootBundle.loadString(fileName);
      final list = await json.decode(jsonData) as List<dynamic>;
      return list.map((azkarModel) => AzkarModel.fromJson(azkarModel)).toList();
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}

class AzkarItem extends StatefulWidget {
  final AzkarModel azkar;

  const AzkarItem({Key? key, required this.azkar}) : super(key: key);

  @override
  _AzkarItemState createState() => _AzkarItemState();
}

class _AzkarItemState extends State<AzkarItem> {
  int _currentCount = 0;

  @override
  Widget build(BuildContext context) {
    double progress = (_currentCount / int.parse(widget.azkar.repeat));

    return Container(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const LinearBorder(),
        ),
      onPressed: (){
        if (_currentCount < int.parse(widget.azkar.repeat)) {
          setState(() {
            _currentCount++;
          });
        }
      },
        child: Card(
          color: KTextWhite,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.right,
                    "  الذكر:  ${widget.azkar.zekr}",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (_currentCount < int.parse(widget.azkar.repeat)) {
                            setState(() {
                              _currentCount++;
                            });
                          }
                        },
                        child: CircularPercentIndicator(
                          radius: 30.0,
                          lineWidth: 5.0,
                          percent: progress,
                          center: Text(
                            '$_currentCount / ${widget.azkar.repeat}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          progressColor: Colors.blueGrey,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.right,
                        "   :  التكرار",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pacifico',
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.right,
                    "البركه:  ${widget.azkar.bless}",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
