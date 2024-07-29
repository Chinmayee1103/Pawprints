import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  String _uid = '';
  String _name = '';
  String _location = '';
  String _time = '';
  String _date = '';
  String _description = '';
  String _uploadedFileURL = '';

  File? _imageFile;
  bool _isImageUploaded = false;

  @override
  void initState() {
    super.initState();
    _getUID();
  }

  void _getUID() {
    setState(() {
      _uid = _auth.currentUser!.uid;
    });
  }

  Future<void> _chooseFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isImageUploaded = true;
      });
    }
  }

  Future<void> _uploadFile() async {
    setState(() {
      isLoading = true;
    });
    if (_imageFile != null) {
      try {
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('Events/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageReference.putFile(_imageFile!);
        final snapshot = await uploadTask.whenComplete(() {});
        final fileURL = await snapshot.ref.getDownloadURL();

        setState(() {
          _uploadedFileURL = fileURL;
          isLoading = false;
        });

        print('File URL: $_uploadedFileURL'); // Debug print
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error uploading file: $e'); // Log error
      }
    }
  }

  Future<void> _submitData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _firestore.collection('shelters').doc(_uid).collection('events').add({
        'name': _name,
        'location': _location,
        'time': _time,
        'date': _date,
        'description': _description,
        'imageURL': _uploadedFileURL.isNotEmpty ? _uploadedFileURL : '', // Ensure URL is not null
        'registrations': [],
      });

      setState(() {
        isLoading = false;
      });

      Navigator.pop(context, true); // Indicate success
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error adding event: $e'); // Log error
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 130, 185, 239), Color.fromARGB(255, 59, 163, 201)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.0),
                      Text(
                        'Add Event',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Event Name',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Event name is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _name = value;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Date',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _date = value;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Time',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Time is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _time = value;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Location',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Location is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _location = value;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Description is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _description = value;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                if (_isImageUploaded)
                                  _imageFile == null
                                      ? Image.asset('images/placeholder.png')
                                      : Image.file(
                                          _imageFile!,
                                          height: 50.0,
                                          width: 50.0,
                                        ),
                                SizedBox(width: 20.0),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  ),
                                  onPressed: _isImageUploaded ? _uploadFile : _chooseFile,
                                  child: Text(
                                    _isImageUploaded ? 'UPLOAD POSTER' : 'CHOOSE POSTER',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              ),
                              child: Text(
                                'ADD EVENT',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_isImageUploaded && _uploadedFileURL.isEmpty) {
                                    await _uploadFile();
                                  }
                                  _submitData();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
