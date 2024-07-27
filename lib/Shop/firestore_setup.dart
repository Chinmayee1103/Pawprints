import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

// Function to upload image
Future<String> uploadImage(String filePath, String imageName) async {
  final imageFile = File(filePath);

  if (!imageFile.existsSync()) {
    print('File does not exist at path: ${imageFile.path}');
    throw Exception('File does not exist');
  }

  try {
    print('Uploading image: ${imageFile.path}');
    final storageRef =
        FirebaseStorage.instance.ref().child('images/$imageName');
    final uploadTask = storageRef.putFile(imageFile);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double percentage = (snapshot.bytesTransferred.toDouble() /
              snapshot.totalBytes.toDouble()) *
          100;
      print('Upload progress: $percentage% ');
    });

    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('Download URL: $downloadUrl');
    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    throw e;
  }
}

// Function to add product to Firestore
Future<void> addProductToFirestore(String collection, String subcollection,
    Map<String, dynamic> productData) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore
        .collection('ecommerce')
        .doc(collection)
        .collection(subcollection)
        .add(productData);
    print('Product added to Firestore: $productData');
  } catch (e) {
    print('Error adding product to Firestore: $e');
    throw e;
  }
}

// Function to create Firestore structure
Future<void> createFirestoreStructure() async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Create main collections
    await firestore.collection('ecommerce').doc('dogshopping').set({});
    await firestore.collection('ecommerce').doc('catshopping').set({});

    // Define subcollections
    final dogSubcollections = ['dogtoys', 'dogfood', 'doghealth', 'dogaccess'];
    final catSubcollections = ['cattoys', 'catfood', 'cathealth', 'cataccess'];

    // Create subcollections with an example document for dogshopping
    for (var sub in dogSubcollections) {
      await firestore
          .collection('ecommerce')
          .doc('dogshopping')
          .collection(sub)
          .doc('exampleDoc')
          .set({'exampleField': 'exampleValue'});
    }

    // Create subcollections with an example document for catshopping
    for (var sub in catSubcollections) {
      await firestore
          .collection('ecommerce')
          .doc('catshopping')
          .collection(sub)
          .doc('exampleDoc')
          .set({'exampleField': 'exampleValue'});
    }

    // Upload images and get URLs
    final dogFoodImage1Url = await uploadImage(
        'C:/VS CODE/Flutter Project/pet_adoption/assets/product3.jpeg',
        'product3.jpeg'); // Path to the image and the name to be used in Firebase Storage

    final dogFoodImage2Url = await uploadImage(
        'C:/VS CODE/Flutter Project/pet_adoption/assets/product4.jpeg',
        'product4.jpeg'); // Path to the image and the name to be used in Firebase Storage

    // Add products with images
    await addProductToFirestore('dogshopping', 'dogfood', {
      'name': 'Premium Dog Food',
      'price': 29.99,
      'description': 'High-quality dog food for all breeds.',
      'image': dogFoodImage1Url,
      'rating': 4.5,
    });

    await addProductToFirestore('dogshopping', 'dogfood', {
      'name': 'Deluxe Dog Food',
      'price': 49.99,
      'description': 'Premium dog food with added nutrients.',
      'image': dogFoodImage2Url,
      'rating': 4.7,
    });

    // Add sample products to the catfood subcollection
    await addProductToFirestore('catshopping', 'catfood', {
      'name': 'Premium Cat Food',
      'price': 19.99,
      'description': 'High-quality cat food for all breeds.',
      'image': '', // Add URL if available
      'rating': 4.3,
    });

    await addProductToFirestore('catshopping', 'catfood', {
      'name': 'Deluxe Cat Food',
      'price': 39.99,
      'description': 'Premium cat food with added nutrients.',
      'image': '', // Add URL if available
      'rating': 4.6,
    });
  } catch (e) {
    print('Error creating Firestore structure: $e');
  }
}

// Example usage function
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
