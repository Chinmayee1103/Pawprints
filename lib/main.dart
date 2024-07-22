import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pet_adoption/AdoptionPage.dart';
import 'package:pet_adoption/CarePage.dart';
import 'package:pet_adoption/ChoicePage.dart';
import 'package:pet_adoption/First.dart';
import 'package:pet_adoption/HelpingHands.dart';
import 'package:pet_adoption/LikedPetsProvider.dart';
import 'package:pet_adoption/loginpage.dart';
import 'package:pet_adoption/intro_screen.dart';
import 'package:pet_adoption/EcommercePage.dart'; // Import EcommercePage

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Enable debug paint size
  //debugPaintSizeEnabled = true;

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
          '/intro': (context) => intro_screen(),
          '/adoption': (context) => AdoptionPage(),
          '/care': (context) => CarePage(),
          '/helpingHands': (context) => HelpingHands(),
          '/login': (context) => LoginPage(),
          '/choice': (context) => ChoicePage(),
          LoginPage.id: (context) => LoginPage(),
          First.id: (context) => First(),
          ChoicePage.id: (context) => ChoicePage(),
          EcommercePage.id: (context) =>
              EcommercePage(), // Add EcommercePage route
        },
      ),
    );
  }
}
