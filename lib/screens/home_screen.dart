import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  final bool isMount = true;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  dynamic coverImage = [
    "assets/images/music_cover/wall_1.jpg",
    "assets/images/music_cover/wall_2.jpg",
    "assets/images/music_cover/wall_4.jpg",
    "assets/images/music_cover/wall_6.jpg",
  ];
  late Random rnd;

  buildImage() {
    int min = 0;
    int max = coverImage.length - 1;
    rnd = Random();
    int r = min + rnd.nextInt(max - min);
    String imageName = coverImage[r].toString();
    return Image.asset(
      imageName.toString(),
      width: double.infinity,
      height: 350,
      fit: BoxFit.cover,
    );
  }

  @override
  void initState() {
    super.initState();

    // listen to states : playing, paused, stopped
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // listen to audio duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // listen to audio position
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future setAudio() async {
    // repeat song when completed
    _audioPlayer.setReleaseMode(ReleaseMode.loop);

    // to play from local-files
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);
    if (result != null) {
      final file = File(result.files.single.path!);
      _audioPlayer.setSourceUrl(file.path);
    }
  }

  // @override
  // void dispose() {
  //   _audioPlayer.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 2,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.keyboard_double_arrow_left_sharp,
                color: Colors.amberAccent,
                size: 35,
              )),
          title: Text(
            "music 🪷",
            style:
                TextStyle(letterSpacing: 3, color: Colors.redAccent.shade700),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            DropShadowImage(
              offset: const Offset(20, 20),
              scale: 5,
              blurRadius: 150,
              borderRadius: 20,
              image: buildImage(),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Song Name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Slider(
                activeColor: Colors.amber,
                inactiveColor: Colors.red.shade200,
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(position);
                  // optional : play audio if was paused
                  await _audioPlayer.resume();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  position.toString().substring(0, 7),
                ),
                Text((duration - position).toString().substring(0, 7))
              ],
            ),
            IconButton(
              color: Colors.amber,
              onPressed: () async {
                if (_isPlaying) {
                  await _audioPlayer.pause();
                } else {
                  await _audioPlayer.resume();
                }
              },
              icon: Icon(
                  size: 50,
                  _isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // ElevatedButton(
            //     onPressed: () {
            //       if (widget.isMount) {
            //         setState(() {
            //           setAudio();
            //         });
            //       }
            //     },
            //     style: ButtonStyle(
            //         backgroundColor:
            //             MaterialStateProperty.all(Colors.redAccent.shade400),
            //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //             RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(30.0),
            //         ))),
            //     child: const Text(
            //       "select your song",
            //       style: TextStyle(fontSize: 18),
            //     )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black12,
        tooltip: 'select your song',
        child: const Icon(
          FontAwesomeIcons.music,
        ),
        onPressed: () {
          if (widget.isMount) {
            setState(() {
              setAudio();
            });
          }
        },
      ),
    );
  }
}
