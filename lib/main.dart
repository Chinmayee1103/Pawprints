import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pet_adoption/AdoptionPage.dart';
import 'package:pet_adoption/CarePage.dart';
import 'package:pet_adoption/First.dart';
import 'package:pet_adoption/HelpingHands.dart';
import 'package:pet_adoption/intro_screen.dart';
import 'package:pet_adoption/loginpage.dart';
import 'package:pet_adoption/ChoicePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Adoption and Care',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: intro_screen(),
      routes: {
        '/adoption': (context) => AdoptionPage(),
        '/care': (context) => CarePage(),
        '/helpingHands': (context) => HelpingHands(),
      },
    );
  }
}
