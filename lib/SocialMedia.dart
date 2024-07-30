import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:pet_adoption/AddStrayPetPage.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media for Stray Pets'),
        backgroundColor: Color(0xffF6C953), // Background color
      ),
      body: Container(
        color: Color(0xffF6C953), // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('strayPets').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print('Firestore error: ${snapshot.error}'); // Print error details
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final pets = snapshot.data?.docs ?? [];
                  if (pets.isEmpty) {
                    return Center(child: Text('No stray pets found.'));
                  }
                  return ListView.builder(
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(pet['name'] ?? 'No name'),
                          subtitle: Text('Location: ${pet['location'] ?? 'Unknown'}'),
                          leading: pet['imageUrl'] != null && pet['imageUrl'].isNotEmpty
                              ? Image.network(pet['imageUrl'])
                              : Icon(Icons.pets),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to add new stray pet
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStrayPetPage()),
                );
              },
              child: Text('Add New Stray Pet'),
            ),
          ],
        ),
      ),
    );
  }
}



