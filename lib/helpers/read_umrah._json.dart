import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/models/umrah_model.dart';

// ignore: must_be_immutable
class ReadUmrahJson extends StatefulWidget {
  ReadUmrahJson({super.key, required this.path});
  String path;

  @override
  State<ReadUmrahJson> createState() => _ReadUmrahJsonState();
}

class _ReadUmrahJsonState extends State<ReadUmrahJson> {
  @override
  Widget build(BuildContext context) {
    //final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          //for add image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context)
                  .size
                  .width, // Set container width to match the screen width
              height: MediaQuery.of(context).size.height *
                  0.3, // Set container height to 50% of the screen height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/R.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          FutureBuilder(
            
              future: readJson(widget.path),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<UmrahModel> umrah = snapshot.data as List<UmrahModel>;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                     shrinkWrap: true,
                    itemCount: umrah.length,
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
                                    "  خطوه:  ${umrah[index].name}",
                                    style:
                                        const TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    "   الوصف:  ${umrah[index].description}",
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    "التفاصيل:  ${umrah[index].details}",
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
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

  Future<List<UmrahModel>> readJson(String fileName) async {
    try {
      final jsonData = await rootBundle.loadString(fileName);
      final list = await json.decode(jsonData) as List<dynamic>;
      //['azkar'];
      return list.map((umrahModel) => UmrahModel.fromJson(umrahModel)).toList();
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
