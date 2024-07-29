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
    setState(() {
      isLoading = true;
    });
    if (_imageFile != null) {
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
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Error uploading file: $e');
      }
    }
  }

  Future<void> _submitData() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoading = true;
    });

    try {
      // Create a map with pet data
      final petData = {
        'name': _name,
        'breed': _breed,
        'description': _description,
        'imageURL': _uploadedFileURL,
      };

      // Determine the collection based on the pet type
      String collectionName = _petType == 'dog' ? 'dogs' : 'cats';

      // Create or update the pet document in Firestore
      await _firestore
          .collection('organizations')
          .doc(_uid) // This should be the organization ID
          .collection(collectionName) // Use the selected pet type
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Pets'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Pet Name'),
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
                  decoration: InputDecoration(labelText: 'Breed'),
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
                  decoration: InputDecoration(labelText: 'Description'),
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
                  decoration: InputDecoration(labelText: 'Pet Type'),
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
                        height: 50.0,
                        width: 50.0,
                      ),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: _chooseFile,
                      child: Text('Choose Image'),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                if (_imageFile != null)
                  ElevatedButton(
                    onPressed: _uploadFile,
                    child: Text('Upload Image'),
                  ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submitData,
                  child: Text('Add Pet'),
                ),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
