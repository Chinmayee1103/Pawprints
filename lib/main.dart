import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pet_adoption/HelpingHands.dart';
import 'package:pet_adoption/SocialMediaPage.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:pet_adoption/AdoptionPage.dart';
import 'package:pet_adoption/CarePage.dart';
import 'package:pet_adoption/ChoicePage.dart';
import 'package:pet_adoption/First.dart';

import 'package:pet_adoption/LikedPetsProvider.dart';
import 'package:pet_adoption/loginpage.dart';
import 'package:pet_adoption/intro_screen.dart';
import 'package:pet_adoption/EcommercePage.dart'; // Import EcommercePage
import 'package:pet_adoption/Shop/CatShoppingPage.dart';
import 'package:pet_adoption/Shop/DogShoppingPage.dart';
import 'package:pet_adoption/Shop/ShopNowPage.dart';
import 'package:pet_adoption/Shop/DogFood.dart';
import 'package:pet_adoption/Shop/DogToys.dart';
import 'package:pet_adoption/Shop/DogHealth.dart';
import 'package:pet_adoption/Shop/DogAccess.dart';
import 'package:pet_adoption/Shop/ProductDetailsPage.dart'; // Import ProductDetailsPage

// Import your Firestore setup file
import 'package:pet_adoption/Shop/firestore_setup.dart';

Future<void> requestPermissions() async {
  await Permission.storage.request();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupAndAddSampleProducts(); // Call the setup function here
  await requestPermissions(); // Request permissions if needed

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
          DogShoppingPage.id: (context) => DogShoppingPage(),
          CatShoppingPage.id: (context) => CatShoppingPage(),
          'shop_now_page': (context) => ShopNowPage(),
          'dog_food_page': (context) => DogFood(),
          'dog_toys_page': (context) => DogToys(),
          'dog_health_page': (context) => DogHealth(),
          'dog_access_page': (context) => DogAccess(),
          // '/organizationRequests': (context) => OrganizationRequests(organizationId: ''), // Add OrganizationRequests route
          '/social-media': (context) => SocialMediaPage(),
        },
        // onGenerateRoute: (settings) {
        //   switch (settings.name) {
        //     case 'product_details_page':
        //       final product = settings.arguments as Map<String, dynamic>;
        //       return MaterialPageRoute(
        //         builder: (context) => ProductDetailsPage(product: product),
        //       );
        //     default:
        //       return null; // Return null for routes not handled
        //   }
        // },
      ),
    );
  }
}
