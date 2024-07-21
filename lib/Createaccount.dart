import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pet_adoption/LoginPage.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  String _errorMessage = '';
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('Picked image path: ${pickedFile.path}');
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xffF6C953),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xffF6C953),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Picture Section
                  Container(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 70.0,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : AssetImage('assets/default_profile.png')
                                      as ImageProvider,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: IconButton(
                            icon: Icon(Icons.add_a_photo,
                                size: 30, color: Colors.blue),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Form Fields
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      labelText: 'State',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _errorMessage = '';
                      });
                      try {
                        // Create user in Firebase Authentication
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        User? user = userCredential.user;

                        // Update Firestore users table
                        if (user != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .set({
                            'name': _nameController.text,
                            'email': _emailController.text,
                            'phone': _phoneController.text,
                            'city': _cityController.text,
                            'state': _stateController.text,
                            // Removed profileImageUrl field
                          });
                        }

                        // Navigate to Login Page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          if (e.code == 'weak-password') {
                            _errorMessage =
                                'The password provided is too weak.';
                          } else if (e.code == 'email-already-in-use') {
                            _errorMessage =
                                'The account already exists for that email.';
                          } else {
                            _errorMessage = e.message ?? 'An error occurred.';
                          }
                        });
                      }
                    },
                    child: Text('Create Account'),
                  ),
                  SizedBox(height: 10.0),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
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
