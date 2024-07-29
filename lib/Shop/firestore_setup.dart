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

Future<void> createFirestoreStructure() async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Create main collections if they don't exist
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

    // Upload images from assets and get URLs
    final dogFoodImage1Url =
        await uploadAssetImage('assets/product3.jpeg', 'product3.jpeg');
    final dogFoodImage2Url =
        await uploadAssetImage('assets/product4.jpeg', 'product4.jpeg');

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
    final catFoodImage1Url =
        await uploadAssetImage('assets/product5.jpeg', 'product5.jpeg');
    final catFoodImage2Url =
        await uploadAssetImage('assets/product6.jpeg', 'product6.jpeg');

    await addProductToFirestore('catshopping', 'catfood', {
      'name': 'Premium Cat Food',
      'price': 19.99,
      'description': 'High-quality cat food for all breeds.',
      'image': catFoodImage1Url,
      'rating': 4.3,
    });

    await addProductToFirestore('catshopping', 'catfood', {
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
