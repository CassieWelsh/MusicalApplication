// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:musical_application/pages/account_page.dart';
import 'package:musical_application/pages/player_page.dart';
import 'package:musical_application/pages/home.dart';
import 'package:musical_application/pages/add_page.dart';

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
  final auth = FirebaseAuth.instance;

  _AppState() {
    tabs = [
      HomePage(changeSong: changeSong),
      PlayerPage(
        player: player,
      ),
      AccountPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: buildAppBar(_currentIndex),
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
              activeIcon: Icon(Icons.play_arrow_rounded),
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

  void changeSong(String songName) async {
    final mountainsRef = await storage.child(songName).getDownloadURL();
    await player.play(UrlSource(mountainsRef));
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  AppBar buildAppBar(int currentIndex) {
    if (_currentIndex == 0)
      return AppBar(
        title: const Text("Popular"),
        backgroundColor: Colors.red,
      );

    if (_currentIndex == 1)
      return AppBar(
        title: const Text("Player"),
        backgroundColor: Colors.red,
      );

    if (_currentIndex == 2)
      return AppBar(
        title: const Text("Account"),
        actions: [
          IconButton(onPressed: addContent, icon: const Icon(Icons.add_circle_outlined)),
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)),
        ],
        backgroundColor: Colors.red,
      );

    return AppBar();
  }

  void addContent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPage()),
    );
  }
}
