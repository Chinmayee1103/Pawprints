import 'package:cloud_firestore/cloud_firestore.dart';

class Auth1 {
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

  
}
