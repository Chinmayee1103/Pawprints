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
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 130, 185, 239), Color.fromARGB(255, 59, 163, 201)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<List<Pet>>(
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
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300], // Placeholder for missing image
                              child: Center(
                                child: Text('No Image Available'),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          pet.name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 59, 163, 201),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Breed: ${pet.breed}',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Description: ${pet.description}',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
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
