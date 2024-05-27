import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/models/hajj_model.dart';

// ignore: must_be_immutable
class ReadHajjJson extends StatefulWidget {
  ReadHajjJson({super.key, required this.path});
  String path;

  @override
  State<ReadHajjJson> createState() => _ReadHajjJsonState();
}

class _ReadHajjJsonState extends State<ReadHajjJson> {
  @override
  Widget build(BuildContext context) {
    return 
    SingleChildScrollView(
      child: Column(
        children: [
             Padding(
            padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
            child: Container(
              width: MediaQuery.of(context)
                  .size
                  .width, // Set container width to match the screen width
              height: MediaQuery.of(context).size.height *
                  0.6, // Set container height to 50% of the screen height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/636701576937052201.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: readJson(widget.path),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<HajjModel> hajj = snapshot.data as List<HajjModel>;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: hajj.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          color: KPrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    "  خطوه:  ${hajj[index].name}",
                                    style:
                                        const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    "   الوصف:  ${hajj[index].description}",
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    "التفاصيل:  ${hajj[index].details}",
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
              }),
        ],
      ),
    );
  }

  Future<List<HajjModel>> readJson(String fileName) async {
    try {
      final jsonData = await rootBundle.loadString(fileName);
      final list = await json.decode(jsonData) as List<dynamic>;
      //['azkar'];
      return list.map((hajjModel) => HajjModel.fromJson(hajjModel)).toList();
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
