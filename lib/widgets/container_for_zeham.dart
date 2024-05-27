import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_app/models/zeham_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// ignore: must_be_immutable
class CustomContainerForZeham extends StatelessWidget {
  CustomContainerForZeham({super.key});
  String? text1;
  String? text2;
  String? text3;
  String? text4;
  int index = 0;
  // @override
  // void initState() {
  //   super.initState();
  //   // Start the timer when the widget is initialized
  //   startTimer();
  // }

  // void startTimer() {
  //   // Create a periodic timer that adds 1 to myVariable every hour
  //   Timer.periodic(const Duration(hours: 1), (Timer timer) {
  //     setState(() {
  //       if(index < 24){
  //         index++;
  //       }else{
  //         index = 0;
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readJson('assets/json/zeham.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          ZehamModel zeham = snapshot.data as ZehamModel;
          List<double> sahnNom = zeham.sahn;
          List<double> ardiNom = zeham.ardi;
          List<double> sathNom = zeham.sath;
          List<double> madinaNom = zeham.madina;

          return Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Text(checkZehamText(sahnNom, zeham)),
                          Text(checkZehamText(ardiNom, zeham)),
                          Text(checkZehamText(sathNom, zeham)),
                          Text(checkZehamText(madinaNom, zeham)),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              width: MediaQuery.of(context).size.width * 0.25,
                              lineHeight: 5.0,
                              percent: sahnNom[index],
                              progressColor: checkZehamColor(sahnNom, zeham),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              width: MediaQuery.of(context).size.width * 0.25,
                              lineHeight: 5.0,
                              percent: ardiNom[index],
                              progressColor: checkZehamColor(ardiNom, zeham),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              width: MediaQuery.of(context).size.width * 0.25,
                              lineHeight: 5.0,
                              percent: sathNom[index],
                              progressColor: checkZehamColor(sathNom, zeham),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              width: MediaQuery.of(context).size.width * 0.25,
                              lineHeight: 5.0,
                              percent: madinaNom[index],
                              progressColor: checkZehamColor(madinaNom, zeham),
                            ),
                          ),
                        ],
                      ),
                      const Column(
                        children: [
                          Text('الصحن'),
                          Text('الاول'),
                          Text('السطح'),
                          Text('المدينه '),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return Container(); // Return an empty container if no data
        }
      },
    );
  }

  String checkZehamText(List<double> list, ZehamModel zeham) {
    String text = '';
    if (list.isNotEmpty) {
      if (list[index] < 0.2) {
        text = 'خفيف جدا';
      } else if (list[index] < 0.4) {
        text = 'خفيف';
      } else if (list[index] < 0.6) {
        text = 'متوسط';
      } else if (list[index] < 0.8) {
        text = 'مزدحم';
      } else if (list[index] < 1.0) {
        text = 'مزدحم جدا';
      }
    }
    return text;
  }

  Color? checkZehamColor(List<double> list, ZehamModel zeham) {
    Color? color;
    if (list.isNotEmpty) {
      if (list[index] < 0.2) {
        color = const Color(0xff85A2B5);
      } else if (list[index] < 0.4) {
        color = const Color(0xff56A8A9);
      } else if (list[index] < 0.6) {
        color = const Color(0xff82922A);
      } else if (list[index] < 0.8) {
        color = const Color(0xfff57201);
      } else if (list[index] < 1.0) {
        color = const Color(0xffc42100);
      }
    }
    return color;
  }

  Future<ZehamModel?> readJson(String path) async {
    try {
      String jsonString = await rootBundle.loadString(path);
      final jsonData = jsonDecode(jsonString);
      return ZehamModel.fromJson(jsonData[0]);
    } catch (e) {
      print('Error reading JSON: $e');
      return null;
    }
  }
}
