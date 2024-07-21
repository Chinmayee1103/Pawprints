import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_adoption/AdoptionPage.dart';
import 'package:pet_adoption/CarePage.dart';
import 'package:pet_adoption/ChoicePage.dart';
import 'package:pet_adoption/First.dart';
import 'package:pet_adoption/HelpingHands.dart';
import 'package:pet_adoption/LikedPetsProvider.dart';
import 'package:pet_adoption/loginpage.dart';
import 'package:provider/provider.dart';
//import 'package:pet_adoption/first.dart';
import 'package:pet_adoption/intro_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LikedPetsProvider(), // Provide the provider here
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pet Adoption and Care',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: intro_screen(), // Set initial route
        routes: {
          '/intro': (context) =>
              intro_screen(), // Ensure IntroScreen is correctly named
          '/adoption': (context) => AdoptionPage(),
          '/care': (context) => CarePage(),
          '/helpingHands': (context) => HelpingHands(),
          '/login': (context) =>
              LoginPage(), // Ensure LoginPage is correctly named
          '/choice': (context) =>
              ChoicePage(),
                  LoginPage.id: (context) => LoginPage(),
    First.id: (context) => First(),
    ChoicePage.id: (context) => ChoicePage(), // Ensure ChoicePage is correctly named
        },
      ),
    );
  }
}
