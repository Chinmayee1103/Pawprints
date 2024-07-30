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

    // Upload images from assets and get URLs for dog food
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

    // Add products to dogfood subcollection
    await addProductToFirestore('dogshopping', 'dogfood', 'Pedigree', {
      'name': 'Pedigree',
      'price': 39.99,
      'description': 'High-quality dog food for all breeds.',
      'image': dogFoodImage1Url,
      'rating': 4.5,
    });

    await addProductToFirestore(
        'dogshopping', 'dogfood', 'The Honest Kitchen', {
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

    await addProductToFirestore('dogshopping', 'dogfood', 'Fresh Pet', {
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

    final catFoodImage1Url =
        await uploadAssetImage('assets/product5.jpeg', 'product5.jpeg');
    final catFoodImage2Url =
        await uploadAssetImage('assets/product6.jpeg', 'product6.jpeg');

    // Add products to catfood subcollection
    await addProductToFirestore(
        'catshopping', 'catfood', 'royal_canin_feline_health_nutrition', {
      'name': 'Royal Canin Feline Health',
      'price': 25.99,
      'description': 'Balanced nutrition for overall health.',
      'image': catFoodImage1Url,
      'rating': 4.5,
    });

    await addProductToFirestore(
        'catshopping', 'catfood', 'hill_s_science_diet_adult_indoor', {
      'name': 'Hill\'s Science Diet Indoor',
      'price': 32.99,
      'description': 'Supports weight control and digestion.',
      'image': catFoodImage2Url,
      'rating': 4.7,
    });

    // Upload images from assets and get URLs for dog toys
    final dogToyImage1Url =
        await uploadAssetImage('assets/dogtoy1.jpeg', 'dogtoy1.jpeg');
    final dogToyImage2Url =
        await uploadAssetImage('assets/dogtoy2.jpeg', 'dogtoy2.jpeg');
    final dogToyImage3Url =
        await uploadAssetImage('assets/dogtoy3.jpeg', 'dogtoy3.jpeg');
    final dogToyImage4Url =
        await uploadAssetImage('assets/dogtoy4.jpeg', 'dogtoy4.jpeg');
    final dogToyImage5Url =
        await uploadAssetImage('assets/dogtoy5.jpeg', 'dogtoy5.jpeg');

    // Add products to dogtoys subcollection
    await addProductToFirestore('dogshopping', 'dogtoys', 'Chew Toy', {
      'name': 'Chew Toy',
      'price': 12.99,
      'description': 'Durable chew toy for your dog’s dental health.',
      'image': dogToyImage1Url,
      'rating': 4.8,
    });

    await addProductToFirestore('dogshopping', 'dogtoys', 'Squeaky Ball', {
      'name': 'Squeaky Ball',
      'price': 8.99,
      'description': 'Fun squeaky ball to keep your dog entertained.',
      'image': dogToyImage2Url,
      'rating': 4.6,
    });

    await addProductToFirestore('dogshopping', 'dogtoys', 'Rope Toy', {
      'name': 'Rope Toy',
      'price': 9.99,
      'description': 'Sturdy rope toy for tug-of-war games.',
      'image': dogToyImage3Url,
      'rating': 4.7,
    });

    await addProductToFirestore('dogshopping', 'dogtoys', 'Fetch Stick', {
      'name': 'Fetch Stick',
      'price': 14.99,
      'description': 'Perfect fetch toy for outdoor play.',
      'image': dogToyImage4Url,
      'rating': 4.9,
    });

    await addProductToFirestore('dogshopping', 'dogtoys', 'Plush Toy', {
      'name': 'Plush Toy',
      'price': 19.99,
      'description': 'Soft plush toy for your dog to cuddle.',
      'image': dogToyImage5Url,
      'rating': 4.5,
    });

    // Upload images from assets and get URLs for cat toys
    final catToyImage1Url =
        await uploadAssetImage('assets/cattoy1.jpeg', 'cattoy1.jpeg');
    final catToyImage2Url =
        await uploadAssetImage('assets/cattoy2.jpeg', 'cattoy2.jpeg');
    final catToyImage3Url =
        await uploadAssetImage('assets/cattoy3.jpeg', 'cattoy3.jpeg');
    final catToyImage4Url =
        await uploadAssetImage('assets/cattoy4.jpeg', 'cattoy4.jpeg');
    final catToyImage5Url =
        await uploadAssetImage('assets/cattoy5.jpeg', 'cattoy5.jpeg');

    // Add products to cattoys subcollection
    await addProductToFirestore('catshopping', 'cattoys', 'Catnip Toy', {
      'name': 'Catnip Toy',
      'price': 7.99,
      'description': 'Catnip-filled toy for your cat’s enjoyment.',
      'image': catToyImage1Url,
      'rating': 4.8,
    });

    await addProductToFirestore('catshopping', 'cattoys', 'Feather Wand', {
      'name': 'Feather Wand',
      'price': 11.99,
      'description': 'Interactive feather wand for playful cats.',
      'image': catToyImage2Url,
      'rating': 4.7,
    });

    await addProductToFirestore('catshopping', 'cattoys', 'Laser Pointer', {
      'name': 'Laser Pointer',
      'price': 9.99,
      'description': 'Laser pointer to keep your cat active.',
      'image': catToyImage3Url,
      'rating': 4.9,
    });

    await addProductToFirestore('catshopping', 'cattoys', 'Scratching Post', {
      'name': 'Scratching Post',
      'price': 24.99,
      'description': 'Durable scratching post to save your furniture.',
      'image': catToyImage4Url,
      'rating': 4.6,
    });

    await addProductToFirestore('catshopping', 'cattoys', 'Plush Mouse', {
      'name': 'Plush Mouse',
      'price': 5.99,
      'description': 'Soft plush mouse for your cat to pounce on.',
      'image': catToyImage5Url,
      'rating': 4.5,
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
