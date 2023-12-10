import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../components/audioplayer.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.url, required this.player});

  final String url;
  final AudioPlayer player;

  @override
  State<PlayerPage> createState() => _PlayerPageState(url: url, player: player);
}

class _PlayerPageState extends State<PlayerPage> {
  final String url;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final AudioPlayer player;

  _PlayerPageState({required this.url, required this.player});

  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
    return Player(url: url, player: player);
  }
}
