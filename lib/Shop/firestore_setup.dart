import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

// Function to upload asset image
Future<String> uploadAssetImage(String assetPath, String imageName) async {
  final ByteData data = await rootBundle.load(assetPath);
  final Uint8List bytes = data.buffer.asUint8List();

  try {
    print('Uploading image from asset: $assetPath');
    final storageRef =
        FirebaseStorage.instance.ref().child('images/$imageName');
    final uploadTask = storageRef.putData(bytes);

    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('Download URL: $downloadUrl');
    return downloadUrl;
  } catch (e) {
    print('Error uploading asset image: $e');
    throw e;
  }
}

// Function to add a product to Firestore with a unique document ID
Future<void> addProductToFirestore(String collection, String subcollection,
    String docId, Map<String, dynamic> productData) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore
        .collection('ecommerce')
        .doc(collection)
        .collection(subcollection)
        .doc(docId)
        .set(productData);
    print('Product added to Firestore: $productData');
  } catch (e) {
    print('Error adding product to Firestore: $e');
    throw e;
  }
}

// Function to create Firestore structure and add sample products
Future<void> createFirestoreStructure() async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Check if the main collections exist, create if not
    final ecommerceCollection = firestore.collection('ecommerce');
    final dogShoppingDoc = ecommerceCollection.doc('dogshopping');
    final catShoppingDoc = ecommerceCollection.doc('catshopping');

    final dogShoppingExists = (await dogShoppingDoc.get()).exists;
    final catShoppingExists = (await catShoppingDoc.get()).exists;

    if (!dogShoppingExists) {
      await dogShoppingDoc.set({});
    }
    if (!catShoppingExists) {
      await catShoppingDoc.set({});
    }

    // Define subcollections
    final dogSubcollections = ['dogtoys', 'dogfood', 'doghealth', 'dogaccess'];
    final catSubcollections = ['cattoys', 'catfood', 'cathealth', 'cataccess'];

    // Check for existence of subcollections for dogshopping
    for (var sub in dogSubcollections) {
      final subcollectionRef = dogShoppingDoc.collection(sub);
      final exampleDoc = subcollectionRef.doc('exampleDoc');
      final exampleDocExists = (await exampleDoc.get()).exists;

      if (!exampleDocExists) {
        await exampleDoc.set({'exampleField': 'exampleValue'});
      }
    }

    // Check for existence of subcollections for catshopping
    for (var sub in catSubcollections) {
      final subcollectionRef = catShoppingDoc.collection(sub);
      final exampleDoc = subcollectionRef.doc('exampleDoc');
      final exampleDocExists = (await exampleDoc.get()).exists;

      if (!exampleDocExists) {
        await exampleDoc.set({'exampleField': 'exampleValue'});
      }
    }

    // Upload images from assets and get URLs
    final dogFoodImage1Url =
        await uploadAssetImage('assets/product1.jpeg', 'product1.jpeg');
    final dogFoodImage2Url =
        await uploadAssetImage('assets/product2.jpg', 'product2.jpg');
    final dogFoodImage3Url =
        await uploadAssetImage('assets/product3.jpeg', 'product3.jpeg');
    final dogFoodImage4Url =
        await uploadAssetImage('assets/product4.jpeg', 'product4.jpeg');
    final dogFoodImage5Url =
        await uploadAssetImage('assets/product5.jpeg', 'product5.jpeg');

    // Add products with unique IDs to avoid duplicates
    await addProductToFirestore('dogshopping', 'dogfood', 'Pedigree', {
      'name': 'Pedigree',
      'price': 39.99,
      'description': 'High-quality dog food for all breeds.',
      'image': dogFoodImage1Url,
      'rating': 4.5,
    });

    await addProductToFirestore('dogshopping', 'dogfood', 'deluxe_dog_food', {
      'name': 'The Honest Kitchen',
      'price': 29.00,
      'description': 'Dehydrated Raw Food.',
      'image': dogFoodImage2Url,
      'rating': 4.7,
    });

    await addProductToFirestore('dogshopping', 'dogfood', 'Blue Buffalo', {
      'name': 'Blue Buffalo',
      'price': 50.00,
      'description': 'Natural Dog Food.',
      'image': dogFoodImage3Url,
      'rating': 4.7,
    });

    await addProductToFirestore('dogshopping', 'dogfood', 'fresh_pet', {
      'name': 'Fresh Pet',
      'price': 49.99,
      'description': 'Fresh Dog Food.',
      'image': dogFoodImage4Url,
      'rating': 4.7,
    });

    await addProductToFirestore('dogshopping', 'dogfood', 'Ollie', {
      'name': 'Ollie',
      'price': 49.99,
      'description': 'Customized Fresh Food.',
      'image': dogFoodImage5Url,
      'rating': 4.7,
    });

    // Add sample products to the catfood subcollection
    final catFoodImage1Url =
        await uploadAssetImage('assets/product5.jpeg', 'product5.jpeg');
    final catFoodImage2Url =
        await uploadAssetImage('assets/product6.jpeg', 'product6.jpeg');

    await addProductToFirestore('catshopping', 'catfood', 'premium_cat_food', {
      'name': 'Premium Cat Food',
      'price': 19.99,
      'description': 'High-quality cat food for all breeds.',
      'image': catFoodImage1Url,
      'rating': 4.3,
    });

    await addProductToFirestore('catshopping', 'catfood', 'deluxe_cat_food', {
      'name': 'Deluxe Cat Food',
      'price': 39.99,
      'description': 'Premium cat food with added nutrients.',
      'image': catFoodImage2Url,
      'rating': 4.6,
    });
  } catch (e) {
    print('Error creating Firestore structure: $e');
  }
}

// Function to initialize Firestore and add sample products
Future<void> setupAndAddSampleProducts() async {
  await createFirestoreStructure();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupAndAddSampleProducts();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore Setup Example'),
        ),
        body: Center(
          child: Text('Firestore setup complete and sample products added.'),
        ),
      ),
    );
  }
}
