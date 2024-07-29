import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  
}
