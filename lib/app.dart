import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:musical_application/components/audioplayer.dart';
import 'package:musical_application/pages/home.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  late final List<Widget> tabs;
  final AudioPlayer player = AudioPlayer();
  final storage = FirebaseStorage.instance.ref();
  String url = '';

  _AppState() {
    tabs = [
      HomePage(changeSong: changeSong),
      Player(
        url: url,
        player: player,
      ),
      const Center(child: Text('12')),
    ];
  }

  void changeSong(String songName) async {
    final mountainsRef = await storage.child(songName).getDownloadURL();
    await player.pause();
    await player.play(UrlSource(mountainsRef));
    setState(() {
      url = songName;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
          ],
          backgroundColor: Colors.red,
        ),
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.shifting,
          onTap: (ind) {
            setState(() {
              _currentIndex = ind;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow_outlined),
              activeIcon: Icon(Icons.play_lesson_rounded),
              label: "Player",
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              activeIcon: Icon(Icons.account_circle),
              label: "Profile",
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
