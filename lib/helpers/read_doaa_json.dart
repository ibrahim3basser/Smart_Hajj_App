import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/models/doaa_model.dart';

// ignore: must_be_immutable
class ReadDoaaJson extends StatefulWidget {
  static const String id = 'read_doaa_json';
  ReadDoaaJson({super.key, required this.path});
  String path;

  @override
  State<ReadDoaaJson> createState() => _ReadDoaaJsonState();
}

class _ReadDoaaJsonState extends State<ReadDoaaJson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('الأدعية', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: KPrimaryColor,
      ),
      body: FutureBuilder(
          future: readJson(widget.path),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DoaaModel> doaa = snapshot.data as List<DoaaModel>;
              return ListView.builder(
                itemCount: doaa.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.clip,
                                  doaa[index].text,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(
                                    25.0,
                                  )),
                              child: IconButton(
                                icon: const Icon(Icons.play_arrow, color: Colors.orange, size: 35),
                                onPressed: () {
                                  try {
                                    final player = AudioPlayer();
                                    player.play(AssetSource(doaa[index].audio));
                                  } catch (e) {
                                    print(e);
                                  }
                                },
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
    );
  }

  Future<List<DoaaModel>> readJson(String fileName) async {
    try {
      final jsonData = await rootBundle.loadString(fileName);
      final list = await json.decode(jsonData) as List<dynamic>;
      //['azkar'];
      return list.map((doaaModel) => DoaaModel.fromJson(doaaModel)).toList();
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
