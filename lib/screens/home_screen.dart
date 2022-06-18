import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();
    // listen to states : playing, paused, stopped
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // audioPlayer.onPlayerStateChanged.listen((s) {
    //   if (s == AudioPlayerState.PLAYING) {
    //     setState(() => duration = audioPlayer.duration);
    //   } else if (s == AudioPlayerState.STOPPED) {
    //     onComplete();
    //     setState(() {
    //       position = duration;
    //     });
    //   }
    // }, onError: (msg) {
    //   setState(() {
    //     playerState = PlayerState.stopped;
    //     duration = new Duration(seconds: 0);
    //     position = new Duration(seconds: 0);
    //   });
    // });

    // listen to audio duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // listen to audio position
    _audioPlayer.onPositionChanged.listen((newDuration) {
      setState(() {
        position = newDuration;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
  }

  Future setAudio() async {
    // repeat song when completed
    _audioPlayer.setReleaseMode(ReleaseMode.loop);

    String url =
        "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
    _audioPlayer.setSourceUrl(url);

    // // load audio from assets
    // final player = AudioCache(prefix: 'assets/audio/');
    // final url = await player.load('audio1.mp3');
    // _audioPlayer.setSourceAsset(
    //   url.path,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_double_arrow_left_sharp,
              color: Colors.grey,
              size: 35,
            )),
        title: const Text(
          "calming🪷music",
          style: TextStyle(letterSpacing: 2, color: Colors.redAccent),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              "Song Name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              "Singer",
              style: TextStyle(fontSize: 20),
            ),
            Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(position);

                  // optional : play audio if was paused
                  await _audioPlayer.resume();
                }),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(formatTime(position)),
            //     Text(formatTime(duration - position))
            //   ],
            // ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 50,
                onPressed: () async {
                  if (_isPlaying) {
                    await _audioPlayer.pause();
                  } else {
                    await _audioPlayer.resume();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
