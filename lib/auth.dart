import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Basic email format validation
      if (!_isValidEmail(email)) {
        debugPrint("Invalid email format");
        return null;
      }

      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint("Error signing in: $e");
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String city,
    required String state,
    required String profileImage,
  }) async {
    try {
      // Basic email format validation
      if (!_isValidEmail(email)) {
        debugPrint("Invalid email format");
        return null;
      }

      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'city': city,
          'state': state,
          'profileImage': profileImage,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      debugPrint("Error creating user: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        debugPrint("User details fetched: ${doc.data()}");
        return doc.data() as Map<String, dynamic>?;
      } else {
        debugPrint("Document does not exist");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching user details: $e");
      return null;
    }
  }

  Future<void> updateUserDetails({
    required String uid,
    required String name,
    required String phone,
    required String city,
    required String state,
    required String email,
    required String profileImage,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'phone': phone,
        'city': city,
        'state': state,
        'email': email,
        'profileImage': profileImage,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error updating user details: $e");
    }
  }

  // Helper method to validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
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