import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/models/ayat_model.dart';

class ReadAyatForHomeBody extends StatefulWidget {
  final String path;
  const ReadAyatForHomeBody({super.key, required this.path});

  @override
  State<ReadAyatForHomeBody> createState() => _ReadAyatForHomeBodyState();
}

class _ReadAyatForHomeBodyState extends State<ReadAyatForHomeBody> {
  List<AyatModel> ayatList = [];
  int currentIndex = 0;

  late Timer timer;
  @override
  void initState() {
    super.initState();
    readJson().then((loadedAyatList) {
      setState(() {
        ayatList = loadedAyatList;
        startRotation();
      });
    });
  }

  Future<List<AyatModel>> readJson() async {
    try {
      final jsonData = await rootBundle.loadString(widget.path);
      final list = await json.decode(jsonData) as List<dynamic>;
      return list.map((ayatModel) => AyatModel.fromJson(ayatModel)).toList();
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  void startRotation() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % ayatList.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 5, top: 10),
          child: Center(
            child: Text(
              'بَــعـض مــن الآيــات الــقــرآنــيــة',
              style: TextStyle(
                fontSize: 18,
                color: KTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Stack(
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset("assets/images/luxury-golden-islamic-title-frame-for-ramadan-kareem-free-png.webp",
                  fit: BoxFit.cover, height: MediaQuery.of(context).size.height * 0.2, width: MediaQuery.of(context).size.width),
            ),

            // ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: Image.asset(
            //       'assets/images/luxury-golden-islamic-title-frame-for-ramadan-kareem-free-png.webp',
            //       fit: BoxFit.cover,
            //       width: MediaQuery.of(context).size.width,
            //       height: MediaQuery.of(context).size.height * 0.2,
            //     )),
            FutureBuilder<List<AyatModel>>(
              future: readJson(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  ayatList = snapshot.data!;
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05, bottom: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        // height: MediaQuery.of(context).size.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              ayatList[currentIndex].text,
                              style: const TextStyle(fontSize: 16, color: KTextColor, fontWeight: FontWeight.bold, height: 1.5),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
