import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pet_adoption/auth.dart';
import 'ChoicePage.dart';
import 'package:pet_adoption/First.dart';
import 'package:pet_adoption/VerificationPage.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  String _errorMessage = '';
  String _successMessage = '';
  bool isLogin = true;

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      _errorMessage = '';
    });
    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _errorMessage = 'Invalid email format.';
      });
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          setState(() {
            _errorMessage = 'Please verify your email address to continue.';
          });
          await user.sendEmailVerification();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => First()),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    setState(() {
      _errorMessage = '';
      _successMessage = '';
    });

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _errorMessage = 'Invalid email format.';
      });
      return;
    }

    if (!isPasswordStrong(_passwordController.text)) {
      setState(() {
        _errorMessage =
            'Password must be at least 6 characters long and contain at least one number, one special character, and one alphabet.';
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();
        await user.updateProfile(displayName: _nameController.text);
        if (_profileImage != null) {
          String profileImageUrl = await _uploadProfileImage();
          await FirebaseAuth.instance.currentUser
              ?.updatePhotoURL(profileImageUrl);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerificationPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _errorMessage =
              'The email address is already in use by another account.';
        });
      } else {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  Future<String> _uploadProfileImage() async {
    if (_profileImage == null) return '';

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');

    UploadTask uploadTask = storageRef.putFile(_profileImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordStrong(String password) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> resendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      setState(() {
        _errorMessage =
            'A verification email has been sent to ${user.email}. Please check your inbox.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChoicePage()),
            );
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Image Container (Optional)
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20.0),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(
                                  Icons.person,
                                  size: 50.0,
                                  color: Colors.grey[700],
                                )
                              : null,
                          backgroundColor: Colors.grey[300],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Title
                  Text(
                    isLogin ? 'Login' : 'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Registration Fields
                  if (!isLogin) ...[
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
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
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
                  ],
                  // Email and Password Fields (Login)
                  if (isLogin) ...[
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
                  ],
                  SizedBox(height: 20.0),
                  // Submit Button
                  ElevatedButton(
                    onPressed: () async {
                      if (isLogin) {
                        await signInWithEmailAndPassword();
                      } else {
                        await createUserWithEmailAndPassword();
                      }
                    },
                    child: Text(isLogin ? 'Login' : 'Register'),
                  ),
                  SizedBox(height: 10.0),
                  // Error Message
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  // Success Message
                  if (_successMessage.isNotEmpty)
                    Text(
                      _successMessage,
                      style: TextStyle(color: Colors.green),
                    ),
                  SizedBox(height: 10.0),
                  // Resend Verification Email Button
                  if (_errorMessage ==
                      'Please verify your email address to continue.')
                    TextButton(
                      onPressed: resendVerificationEmail,
                      child: Text('Resend Verification Email'),
                    ),
                  SizedBox(height: 10.0),
                  // Google Sign-In Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/google.png',
                          height: 20.0,
                        ),
                        SizedBox(width: 10.0),
                        Text('Sign in with Google'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Toggle between Login and Register
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        _errorMessage = '';
                        _successMessage = '';
                      });
                    },
                    child: Text(
                      isLogin ? 'Create an account' : 'Have an account? Login',
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
