import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'DogScreen.dart'; // Ensure this import matches the actual location of DogScreen.dart
import 'CatScreen.dart'; // Ensure this import matches the actual location of CatScreen.dart

class OrgHome extends StatefulWidget {
  @override
  _OrgHomeState createState() => _OrgHomeState();
}

class _OrgHomeState extends State<OrgHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser!.uid; // Get the current user ID
  }

  Stream<List<Event>> _fetchEvents() {
    return _firestore
        .collection('shelters')
        .doc(_uid)
        .collection('events')
        .snapshots()
        .map((snapshot) {
      final events = snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
      return events;
    }).handleError((error) {
      print('Error fetching events: $error'); // Log error to console
      return [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, 'addEvent');
              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Event successfully added'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
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
        child: StreamBuilder<List<Event>>(
          stream: _fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final events = snapshot.data ?? [];

            if (events.isEmpty) {
              return Center(child: Text('No events available'));
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      event.imageURL.isNotEmpty
                          ? Image.network(
                              event.imageURL,
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
                          event.name,
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
                          'Date: ${event.date}',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Time: ${event.time}',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        child: Text(
                          event.description,
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
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 30,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DogScreen(uid: _uid)),
                );
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.pets, color: Colors.white),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CatScreen(uid: _uid)),
                );
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.pets, color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrgHome()),
                );
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.home, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class Event {
  final String name;
  final String location;
  final String time;
  final String date;
  final String description;
  final String imageURL;

  Event({
    required this.name,
    required this.location,
    required this.time,
    required this.date,
    required this.description,
    required this.imageURL,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      time: map['time'] ?? '',
      date: map['date'] ?? '',
      description: map['description'] ?? '',
      imageURL: map['imageURL'] ?? '',
    );
  }
}
