import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';
import 'package:musical_application/models/dto/trackartist.dart';

class PlayerPage extends StatefulWidget {
  final AudioPlayer player;
  final TrackArtist meta;

  PlayerPage({super.key, required this.player, required this.meta});

  @override
  State<PlayerPage> createState() =>
      _PlayerPageState(player: player, meta: meta);
}

class _PlayerPageState extends State<PlayerPage> {
  _PlayerPageState({required this.player, required this.meta}) {
    isPlaying = player.state == PlayerState.playing;
  }

  final _dataProvider = DataProvider();
  final TrackArtist meta;
  final AudioPlayer player;
  late bool isPlaying;
  static Duration duration = const Duration(hours: 2);
  Duration position = Duration.zero;

  void setAudio() async {
    if (!mounted) {
      return;
    }

    if (player.state != PlayerState.stopped) {
      final pDuration = await player.getDuration();
      duration = pDuration ?? const Duration(hours: 99);
      return;
    }

    duration = const Duration(hours: 99);
  }

  @override
  void initState() {
    super.initState();

    setAudio();

    player.onPlayerStateChanged.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      if (!mounted) {
        return;
      }
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      if (!mounted) {
        return;
      }
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    //player.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  void addSong(){
    _dataProvider.addOrRemoveSong(meta.trackId, meta.isAdded);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 300,
              height: 300,
              color: Colors.grey,
              child: const Icon(
                Icons.music_note,
                size: 175,
                color: Colors.white38,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            meta.trackName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            meta.artistName,
            style: const TextStyle(fontSize: 20),
          ),
          Slider(
            activeColor: Colors.red,
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await player.seek(position);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration)),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 25),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await player.pause();
                    } else {
                      await player.resume();
                    }
                  },
                ),
              ),
              const SizedBox(width: 25),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 25),
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: Icon(meta.isAdded ? Icons.remove : Icons.add),
                  onPressed: () {
                    addSong();
                    setState(() {
                      meta.isAdded = !meta.isAdded;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
