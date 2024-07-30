import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'SocialMediaPage.dart';

class HelpingHands extends StatefulWidget {
  @override
  _HelpingHandsState createState() => _HelpingHandsState();
}

class _HelpingHandsState extends State<HelpingHands> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  File? _imageFile;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('request_images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _currentPosition != null && _imageFile != null) {
      _formKey.currentState!.save();
      String imageUrl = await _uploadImage(_imageFile!);
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Find nearest organization
      QuerySnapshot orgSnapshot = await FirebaseFirestore.instance.collection('organizations').get();
      double minDistance = double.infinity;
      String nearestOrgId = '';

      for (var doc in orgSnapshot.docs) {
        GeoPoint location = doc['location'];
        double distance = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          location.latitude,
          location.longitude,
        );

        if (distance < minDistance) {
          minDistance = distance;
          nearestOrgId = doc.id;
        }
      }

      // Create collection and subcollection if not exist
      final orgRef = FirebaseFirestore.instance.collection('organization_requests').doc(nearestOrgId);
      final requestsRef = orgRef.collection('requests');

      // Save request to Firestore
      await requestsRef.add({
        'description': _description,
        'imageUrl': imageUrl,
        'timestamp': Timestamp.now(),
        'userId': userId,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request sent to the nearest organization')),
      );

      // Navigate back or clear form
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and add a photo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Helping Hands'),
        backgroundColor: Color(0xffE0BA59),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE0BA59), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            'Report a Stray Animal',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3D2715),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.description),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _description = value!;
                            },
                          ),
                          SizedBox(height: 20),
                          _imageFile == null
                              ? Text('No image selected.')
                              : Image.file(_imageFile!, height: 150),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () => _pickImage(ImageSource.camera),
                              ),
                              IconButton(
                                icon: Icon(Icons.photo_library),
                                onPressed: () => _pickImage(ImageSource.gallery),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Submit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffE0BA59),
                              padding: EdgeInsets.symmetric(
                                horizontal: 50.0,
                                vertical: 15.0,
                              ),
                              textStyle: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (FirebaseAuth.instance.currentUser != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SocialMediaPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('You need to be logged in to view the social media page.')),
                                );
                              }
                            },
                            child: Text('View Social Media'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffE0BA59),
                              padding: EdgeInsets.symmetric(
                                horizontal: 50.0,
                                vertical: 15.0,
                              ),
                              textStyle: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// class HelpingHands extends StatefulWidget {
//   @override
//   _HelpingHandsState createState() => _HelpingHandsState();
// }

// class _HelpingHandsState extends State<HelpingHands> {
//   final _formKey = GlobalKey<FormState>();
//   String _description = '';
//   File? _imageFile;
//   Position? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   void _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     setState(() {
//       _currentPosition = position;
//     });
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<String> _uploadImage(File image) async {
//     Reference storageReference = FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
//     UploadTask uploadTask = storageReference.putFile(image);
//     TaskSnapshot taskSnapshot = await uploadTask;
//     return await taskSnapshot.ref.getDownloadURL();
//   }

//   Future<void> _submitForm() async {
//   if (_formKey.currentState!.validate() && _currentPosition != null && _imageFile != null) {
//     _formKey.currentState!.save();
//     String imageUrl = await _uploadImage(_imageFile!);

//     // Find nearest organization
//     QuerySnapshot orgSnapshot = await FirebaseFirestore.instance.collection('organizations').get();
//     double minDistance = double.infinity;
//     String nearestOrgId = '';

//     for (var doc in orgSnapshot.docs) {
//       GeoPoint location = doc['location'];
//       double distance = Geolocator.distanceBetween(
//         _currentPosition!.latitude,
//         _currentPosition!.longitude,
//         location.latitude,
//         location.longitude,
//       );

//       if (distance < minDistance) {
//         minDistance = distance;
//         nearestOrgId = doc.id;
//       }
//     }

//     // Save request to Firestore
//     await FirebaseFirestore.instance.collection('organization_requests').doc(nearestOrgId).collection('requests').add({
//       'description': _description,
//       'imageUrl': imageUrl,
//       'timestamp': Timestamp.now(),
//     });

//     // Notify the organization (you might need a more sophisticated notification mechanism)
//     await FirebaseFirestore.instance.collection('organizations').doc(nearestOrgId).update({
//       'new_request': true, // You can use this field to trigger notifications
//     });

//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Request sent to the nearest organization')),
//     );

//     // Navigate back or clear form
//     Navigator.pop(context);
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please fill all fields and add a photo.')),
//     );
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Helping Hands'),
//         backgroundColor: Color(0xffE0BA59),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xffE0BA59), Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 15.0,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           Text(
//                             'Report a Stray Animal',
//                             style: TextStyle(
//                               fontSize: 28.0,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xff3D2715),
//                             ),
//                           ),
//                           SizedBox(height: 20.0),
//                           TextFormField(
//                             decoration: InputDecoration(
//                               labelText: 'Description',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.description),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter a description';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _description = value!;
//                             },
//                           ),
//                           SizedBox(height: 20),
//                           _imageFile == null
//                               ? Text('No image selected.')
//                               : Image.file(_imageFile!, height: 150),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.camera_alt),
//                                 onPressed: () => _pickImage(ImageSource.camera),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.photo_library),
//                                 onPressed: () => _pickImage(ImageSource.gallery),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 20),
//                           ElevatedButton(
//                             onPressed: _submitForm,
//                             child: Text('Submit'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xffE0BA59),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 50.0,
//                                 vertical: 15.0,
//                               ),
//                               textStyle: TextStyle(
//                                 fontSize: 18.0,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (FirebaseAuth.instance.currentUser != null) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => SocialMediaPage()),
//                                 );
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('You need to be logged in to view the social media page.')),
//                                 );
//                               }
//                             },
//                             child: Text('View Social Media'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xffE0BA59),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 50.0,
//                                 vertical: 15.0,
//                               ),
//                               textStyle: TextStyle(
//                                 fontSize: 18.0,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
