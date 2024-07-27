import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> initializeFirestore() async {
  final firestore = FirebaseFirestore.instance;

  // Create the ecommerce collection
  final ecommerceCollection = firestore.collection('ecommerce');

  // Create dogshopping and catshopping subcollections
  await ecommerceCollection.doc('dogshopping').set({});
  await ecommerceCollection.doc('catshopping').set({});

  // Create subcollections under dogshopping
  await ecommerceCollection
      .doc('dogshopping')
      .collection('dogtoys')
      .doc('example')
      .set({
    'name': 'Sample Dog Toy',
    'price': '\$10',
    'rating': '4.5',
    'image': 'https://example.com/dogtoy.jpg',
  });
  await ecommerceCollection
      .doc('dogshopping')
      .collection('dogfood')
      .doc('example')
      .set({
    'name': 'Sample Dog Food',
    'price': '\$20',
    'rating': '4.7',
    'image': 'https://example.com/dogfood.jpg',
  });
  await ecommerceCollection
      .doc('dogshopping')
      .collection('doghealth')
      .doc('example')
      .set({
    'name': 'Sample Dog Health',
    'price': '\$15',
    'rating': '4.6',
    'image': 'https://example.com/doghealth.jpg',
  });
  await ecommerceCollection
      .doc('dogshopping')
      .collection('dogaccess')
      .doc('example')
      .set({
    'name': 'Sample Dog Accessory',
    'price': '\$25',
    'rating': '4.8',
    'image': 'https://example.com/dogaccess.jpg',
  });

  // Create subcollections under catshopping
  await ecommerceCollection
      .doc('catshopping')
      .collection('catfood')
      .doc('example')
      .set({
    'name': 'Sample Cat Food',
    'price': '\$15',
    'rating': '4.6',
    'image': 'https://example.com/catfood.jpg',
  });
  await ecommerceCollection
      .doc('catshopping')
      .collection('cathealth')
      .doc('example')
      .set({
    'name': 'Sample Cat Health',
    'price': '\$20',
    'rating': '4.7',
    'image': 'https://example.com/cathealth.jpg',
  });
  await ecommerceCollection
      .doc('catshopping')
      .collection('cataccess')
      .doc('example')
      .set({
    'name': 'Sample Cat Accessory',
    'price': '\$18',
    'rating': '4.8',
    'image': 'https://example.com/cataccess.jpg',
  });

  print("Firestore structure initialized.");
}
