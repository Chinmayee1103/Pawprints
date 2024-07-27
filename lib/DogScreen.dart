import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DogScreen extends StatelessWidget {
  final String uid;

  DogScreen({required this.uid});

  Stream<List<Pet>> _fetchPets() {
    return FirebaseFirestore.instance
        .collection('organizations')
        .doc(uid)
        .collection('dogs')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Pet.fromFirestore(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dogs for Adoption'),
      ),
      body: StreamBuilder<List<Pet>>(
        stream: _fetchPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final pets = snapshot.data ?? [];

          if (pets.isEmpty) {
            return Center(child: Text('No dogs available'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pet.imageURL.isNotEmpty
                        ? Image.network(
                            pet.imageURL,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey,
                            width: double.infinity,
                            height: 200,
                            child: Center(child: Text('No Image')),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(pet.name, style: Theme.of(context).textTheme.headlineMedium),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(pet.breed, style: Theme.of(context).textTheme.labelMedium),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(pet.description),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Pet {
  final String name;
  final String breed;
  final String description;
  final String imageURL;

  Pet({
    required this.name,
    required this.breed,
    required this.description,
    required this.imageURL,
  });

  factory Pet.fromFirestore(Map<String, dynamic> data) {
    return Pet(
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
            
      description: data['description'] ?? '',
      imageURL: data['imageURL'] ?? '',
    );
  }
}

