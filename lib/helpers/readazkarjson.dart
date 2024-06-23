import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_app/constants.dart';

import 'package:hajj_app/models/azkar_model.dart';

// ignore: must_be_immutable
class ReadAzkarJson extends StatefulWidget {
  ReadAzkarJson({super.key, required this.path});
  String path;

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
                              "  الذكر:  ${azkar[index].zekr}",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                // textAlign: TextAlign.left,
                                azkar[index].repeat.toString(),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  textAlign: TextAlign.right,
                                  "   :  التكرار",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Pacifico',
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              textAlign: TextAlign.right,
                              "البركه:  ${azkar[index].bless}",
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
        });
  }

  Future<List<AzkarModel>> readJson(String fileName) async {
    try {
      final jsonData = await rootBundle.loadString(fileName);
      final list = await json.decode(jsonData) as List<dynamic>;
      //['azkar'];
      return list.map((azkarModel) => AzkarModel.fromJson(azkarModel)).toList();
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
