import 'package:flutter/material.dart';
import 'package:hajj_app/constants.dart';
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
    _controller = VideoPlayerController.asset("flutter_assets/videos/video.mp4");
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

  void _seekToRelativePosition(Duration offset) {
    final newPosition = _controller.value.position + offset;
    _controller.seekTo(newPosition);
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
                  child: Text(
                    'فيديو لتوضيح اهميه الدعاء وادابه.',
                    style: TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      _VideoControls(
                        controller: _controller,
                        seekToRelativePosition: _seekToRelativePosition,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onTap: () {
                    Navigator.pushNamed(context, ReadDoaaJson.id);
                  },
                  text: ' عرض الادعيه',
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator(color: KPrimaryColor,));
          }
        },
      ),
    );
  }
}

class _VideoControls extends StatelessWidget {
  final VideoPlayerController controller;
  final void Function(Duration offset) seekToRelativePosition;

  const _VideoControls({
    required this.controller,
    required this.seekToRelativePosition,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        VideoProgressIndicator(
          controller,
          allowScrubbing: true,
          colors: const VideoProgressColors(
            playedColor: Colors.orange,
            bufferedColor: Colors.white,
            backgroundColor: Colors.grey,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.replay_5, color: Colors.white),
              onPressed: () => seekToRelativePosition(const Duration(seconds: -5)),
            ),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, VideoPlayerValue value, child) {
                return IconButton(
                  icon: Icon(
                    value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    value.isPlaying ? controller.pause() : controller.play();
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.forward_5, color: Colors.white),
              onPressed: () => seekToRelativePosition(const Duration(seconds: 5)),
            ),
          ],
        ),
      ],
    );
  }
}
