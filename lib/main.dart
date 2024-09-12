import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home.dart'; // Import the file containing HomePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuideUs',
      home: HomePage(),
    );
  }
}
