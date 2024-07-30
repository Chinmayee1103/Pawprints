import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class AddStrayPetPage extends StatefulWidget {
  @override
  _AddStrayPetPageState createState() => _AddStrayPetPageState();
}

class _AddStrayPetPageState extends State<AddStrayPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child('strayPets/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Stray Pet'),
        backgroundColor: Color(0xffF6C953), // Background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Pet Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pet\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Save the form data
                    _saveStrayPet();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveStrayPet() async {
  try {
    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImage(_image!);
    }
    final firestore = FirebaseFirestore.instance;
    final petData = {
      'reportId': DateTime.now().millisecondsSinceEpoch.toString(), // Auto-generate report ID
      'userId': 'some_user_id', // Replace with actual user ID
      'name': _nameController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'imageUrl': imageUrl,
      'reportedAt': Timestamp.now(),
    };

    // Save the stray pet data to the 'strayPets' collection
    await firestore.collection('strayPets').add(petData);

    // Save the same data to the 'OrganizationRequests' collection
    await firestore.collection('OrganizationRequests').add(petData);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stray pet reported successfully!')));
    
    // Go back to the previous screen
    Navigator.pop(context);
  } catch (e) {
    // Handle errors
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error reporting stray pet: $e')));
  }
}

}
