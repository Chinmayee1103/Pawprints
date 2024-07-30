import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManagePets extends StatefulWidget {
  @override
  _ManagePetsState createState() => _ManagePetsState();
}

class _ManagePetsState extends State<ManagePets> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  String _uid = '';
  String _name = '';
  String _breed = '';
  String _description = '';
  String _uploadedFileURL = '';
  String _petType = 'dog'; // Default to 'dog'

  File? _imageFile;
  bool isLoading = false;

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
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_imageFile == null) {
      _showErrorDialog('Please select an image first.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('Pets/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageReference.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final fileURL = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedFileURL = fileURL;
        isLoading = false;
      });

      _submitData(); // Submit data after successful image upload
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Error uploading file: $e');
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final petData = {
          'name': _name,
          'breed': _breed,
          'description': _description,
          'imageURL': _uploadedFileURL,
        };

        String collectionName = _petType == 'dog' ? 'dogs' : 'cats';

        await _firestore
            .collection('organizations')
            .doc(_uid)
            .collection(collectionName)
            .add(petData);

        setState(() {
          isLoading = false;
        });

        Navigator.pop(context, true);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Error adding pet: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login page
    } catch (e) {
      _showErrorDialog('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Pets'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add a Pet',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3D2715),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Pet Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.pets),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pet name is required';
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
                              labelText: 'Breed',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.pets),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Breed is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _breed = value;
                              });
                            },
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
                          DropdownButtonFormField<String>(
                            value: _petType,
                            decoration: InputDecoration(
                              labelText: 'Pet Type',
                              border: OutlineInputBorder(),
                            ),
                            items: ['dog', 'cat'].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type[0].toUpperCase() + type.substring(1)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _petType = value!;
                              });
                            },
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              if (_imageFile != null)
                                Image.file(
                                  _imageFile!,
                                  height: 150.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                ),
                              SizedBox(width: 20.0),
                              ElevatedButton(
                                onPressed: _chooseFile,
                                child: Text('Choose Image'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffE0BA59),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          if (_imageFile != null)
                            ElevatedButton(
                              onPressed: _uploadFile,
                              child: Text('Upload Image'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffE0BA59),
                              ),
                            ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: _submitData,
                            child: Text('Add Pet'),
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
                          if (isLoading)
                            Center(
                              child: CircularProgressIndicator(),
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
