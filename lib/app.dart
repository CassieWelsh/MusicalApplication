import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  _AppState() {
    tabs = [
      HomePage(),
      const Player(url: 'https://firebasestorage.googleapis.com/v0/b/music-service-1bdb3.appspot.com/o/rubeji.mp3?alt=media&token=2ff6b286-bbfa-47d6-9156-cf1c98ffa712'),
      //const Center(child: Text('12')),
    ];
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
