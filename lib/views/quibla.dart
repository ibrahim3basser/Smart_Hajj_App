import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/widgets/quiblah_compass.dart';

class QuiblahPage extends StatefulWidget {
  static String id = 'QuiblahPage';
  const QuiblahPage({super.key});

  @override
  State<QuiblahPage> createState() => _QuiblahPageState();
}

class _QuiblahPageState extends State<QuiblahPage> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    ThemeData.dark().copyWith(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: const Color(0xffecce6d)));
    return Scaffold(
      appBar: AppBar(
        title: const Text("اتجاه القبله",style: TextStyle(color: KTextBrown),),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (_, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          }

          if (snapshot.data!) {
            return const QiblaCompass();
          } else {
            return const Center(
              child: Text("Device not supported"),
            );
          }
        },
      ),
    );
  }
}


