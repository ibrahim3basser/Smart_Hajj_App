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
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  int? _playingIndex;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _playingIndex = null;
        _currentPosition = Duration.zero;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

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
            return Stack(
              children: [
                ListView.builder(
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
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
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
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _isPlaying && _playingIndex == index
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.orange,
                                    size: 35,
                                  ),
                                  onPressed: () async {
                                    if (_isPlaying && _playingIndex == index) {
                                      await _audioPlayer.pause();
                                      setState(() {
                                        _isPlaying = false;
                                        _playingIndex = null;
                                      });
                                    } else {
                                      await _audioPlayer.stop(); // Stop any previous playing audio
                                      await _audioPlayer.play(AssetSource(doaa[index].audio));
                                      setState(() {
                                        _isPlaying = true;
                                        _playingIndex = index;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ]
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (_playingIndex != null) _buildAudioPlayer(),
                SizedBox(height: 2000,),
              ],
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
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: _currentPosition.inSeconds.toDouble(),
              max: _totalDuration.inSeconds.toDouble(),
              onChanged: (double value) async {
                final position = Duration(seconds: value.toInt());
                await _audioPlayer.seek(position);
                setState(() {
                  _currentPosition = position;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.replay_5, color: Colors.orange),
                  onPressed: () async {
                    final newPosition = _currentPosition - Duration(seconds: 5);
                    await _audioPlayer.seek(newPosition);
                  },
                  iconSize: 30,
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.orange,
                    size: 40,
                  ),
                  onPressed: () async {
                    if (_isPlaying) {
                      await _audioPlayer.pause();
                      setState(() {
                        _isPlaying = false;
                      });
                    } else {
                      await _audioPlayer.resume();
                      setState(() {
                        _isPlaying = true;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.forward_5, color: Colors.orange),
                  onPressed: () async {
                    final newPosition = _currentPosition + Duration(seconds: 5);
                    await _audioPlayer.seek(newPosition);
                  },
                  iconSize: 30,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(' / ', style: TextStyle(fontSize: 16)),
                Text(
                  _formatDuration(_totalDuration),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<DoaaModel>> readJson(String fileName) async {
    try {
      final jsonData = await rootBundle.loadString(fileName);
      final list = await json.decode(jsonData) as List<dynamic>;
      return list.map((doaaModel) => DoaaModel.fromJson(doaaModel)).toList();
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
