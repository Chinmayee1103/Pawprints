import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
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
}
