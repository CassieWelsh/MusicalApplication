import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:musical_application/firebase_options.dart';
import 'package:musical_application/pages/auth/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final storage = FirebaseStorage.instance.ref();
  // final mountainsRef = await storage.child('rubeji.mp3').getDownloadURL();
  // print(mountainsRef);
  runApp(const MaterialApp(home: AuthPage()));
}
