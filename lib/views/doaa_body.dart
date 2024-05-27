import 'package:flutter/material.dart';
import 'package:hajj_app/helpers/read_doaa_json.dart';
import 'package:hajj_app/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';

class DoaaBody extends StatefulWidget {
  static const String id = 'doaa_body';
  const DoaaBody({super.key});

  @override
  State<DoaaBody> createState() => _DoaaBodyState();
}

class _DoaaBodyState extends State<DoaaBody> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller =
        VideoPlayerController.asset("flutter_assets/videos/video.mp4");

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('فيديو لتوضيح اهميه الدعاء وادابه.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, ReadDoaaJson.id);
                },
                text: ' عرض الادعيه',

              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}