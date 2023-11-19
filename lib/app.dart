import 'package:flutter/material.dart';
import 'package:musical_application/pages/login_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 1;

  final tabs = [
    const Center(child: Text('Home')),
    LoginPage(),
    //const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              backgroundColor: Colors.green,
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
