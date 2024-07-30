import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Auth1 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> addOrganization({
    required String oname,
    required String oemail,
    required String contactNumber,
    required String address,
  }) async {
    try {
      final CollectionReference organizations =
          FirebaseFirestore.instance.collection('organizations');

      await organizations.add({
        'oname': oname,
        'oemail': oemail,
        'contactNumber': contactNumber,
        'address': address,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Error adding organization: $e');
    }
  }

  Future<void> addOrUpdateOrganization(String name, String address) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('organizations').doc(user.uid).set({
        'name': name,
        'address': address,
      });
    }
  }

  // Add or update a pet
  Future<void> addOrUpdatePet(String petType, Map<String, dynamic> petData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('organizations').doc(user.uid).collection(petType).add(petData);
    }
  }

  // Fetch pets from a specific type
  Stream<List<Map<String, dynamic>>> fetchPets(String petType) {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('organizations')
          .doc(user.uid)
          .collection(petType)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } else {
      return Stream.value([]);
    }
  }

Future<Map<String, dynamic>?> getOrganizationDetails(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('organizations').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching organization details: $e");
      throw e; // Rethrow the error to handle it where the method is called
    }
  }



  Future<void> updateOrganizationDetails({
    required String uid,
    required String name,
    required String contactNumber,
    required String email,
    required String address,
    required String profileImage,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('organizations').doc(uid).update({
        'name': name,
        'contactNumber': contactNumber,
        'email': email,
        'address': address,
        'profileImageUrl': profileImage,
      });
    } catch (e) {
      print("Error updating organization details: $e");
      throw e; // Rethrow the error to handle it where the method is called
    }
  }

Future<void> saveOrganizationDetails({
    required String name,
    required String contactNumber,
    required String email,
    required String address,
    File? imageFile,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String imageUrl = '';

      try {
        // Upload image if selected
        if (imageFile != null) {
          imageUrl = await _uploadImage(user.uid, imageFile);
        }

        // Update the organization details in Firestore
        await updateOrganizationDetails(
          uid: user.uid,
          name: name,
          contactNumber: contactNumber,
          email: email,
          address: address,
          profileImage: imageUrl,
        );

        // Optionally, show a success message
        print('Organization details updated successfully.');
      } catch (e) {
        // Handle errors and provide feedback
        print("Error saving organization details: $e");
      }
    } else {
      // Handle case where no user is logged in
      print('No user is currently logged in.');
    }
  }

Future<String> _uploadImage(String uid, File image) async {
  try {
    final ref = FirebaseStorage.instance
        .ref()
        .child('organization_profile_images')
        .child('$uid.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  } catch (e) {
    print("Error uploading image: $e");
    throw e; // Re-throw the error to handle it where the method is called
  }
}

  
}