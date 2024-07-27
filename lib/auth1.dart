import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Auth1 extends StatefulWidget {
  @override
  _Auth1State createState() => _Auth1State();
}

class _Auth1State extends State<Auth1> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> addOrganization({
    required String oname,
    required String oemail,
    required String contactNumber,
    required String address,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('organizations').add({
        'name': oname,
        'email': oemail,
        'contactNumber': contactNumber,
        'address': address,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Organization data added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding organization data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Organization'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _contactNumberController,
              decoration: InputDecoration(labelText: 'Contact Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await addOrganization(
                  oname: _nameController.text,
                  oemail: _emailController.text,
                  contactNumber: _contactNumberController.text,
                  address: _addressController.text,
                );
                _nameController.clear();
                _emailController.clear();
                _contactNumberController.clear();
                _addressController.clear();
              },
              child: Text('Add Organization'),
            ),
          ],
        ),
      ),
    );
  }
}
