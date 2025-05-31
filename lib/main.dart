import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Chicken House',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFE5D26)),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Smart Chicken House'),
      debugShowCheckedModeBanner: false,
    );
  }
}