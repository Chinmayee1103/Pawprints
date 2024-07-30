import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_adoption/First.dart';
import 'dart:io';
// import 'package:pet_adoption/auth.dart';
import 'ChoicePage.dart';
// import 'package:pet_adoption/First.dart';
import 'package:pet_adoption/VerificationPage.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          setState(() {
            _errorMessage = 'Please verify your email address to continue. Verification email sent again.';
          });
          await user.sendEmailVerification();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => First()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Wrong password provided.';
        } else if (e.code == 'user-disabled') {
          _errorMessage = 'User account has been disabled.';
        } else if (e.code == 'too-many-requests') {
          _errorMessage = 'Too many requests. Please try again later.';
        } else if (e.code == 'network-request-failed') {
          _errorMessage = 'Network error. Please check your internet connection and try again.';
        } else {
          _errorMessage = 'No such account. Please create one';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
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
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();
        await user.updateProfile(displayName: _nameController.text);
        if (_profileImage != null) {
          String profileImageUrl = await _uploadProfileImage();
          await FirebaseAuth.instance.currentUser?.updatePhotoURL(profileImageUrl);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerificationPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _errorMessage = 'The email address is already in use by another account.';
        } else if (e.code == 'weak-password') {
          _errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'operation-not-allowed') {
          _errorMessage = 'Email/password accounts are not enabled.';
        } else if (e.code == 'network-request-failed') {
          _errorMessage = 'Network error. Please check your internet connection and try again.';
        } else {
          _errorMessage = 'No such account.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    }
  }

  Future<String> _uploadProfileImage() async {
    if (_profileImage == null) return '';

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');

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
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> signInWithGoogle() async {
    // Implement Google Sign-In logic here
  }

  Future<void> resendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      setState(() {
        _errorMessage = 'A verification email has been sent to ${user.email}. Please check your inbox.';
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
                    child: Column(
                      children: [
                        Text(
                          'User Login',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D2715),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          '"Every pet deserves a loving home. Be the hero in their story and give them the happily ever after they deserve."',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                            color: Color(0xff3D2715),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30.0),
                        if (_errorMessage.isNotEmpty)
                          Container(
                            color: Colors.amberAccent,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline),
                                SizedBox(width: 10),
                                Expanded(child: Text(_errorMessage)),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _errorMessage = '';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        if (_successMessage.isNotEmpty)
                          Container(
                            color: Colors.lightGreenAccent,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline),
                                SizedBox(width: 10),
                                Expanded(child: Text(_successMessage)),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _successMessage = '';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 20.0),
                        isLogin
                            ? Column(
                                children: [
                                  _buildTextField(
                                      controller: _emailController, labelText: 'Email', icon: Icons.email),
                                  SizedBox(height: 20.0),
                                  _buildTextField(
                                      controller: _passwordController,
                                      labelText: 'Password',
                                      icon: Icons.lock,
                                      obscureText: true),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildTextField(
                                      controller: _emailController, labelText: 'Email', icon: Icons.email),
                                  SizedBox(height: 20.0),
                                  _buildTextField(
                                      controller: _passwordController,
                                      labelText: 'Password',
                                      icon: Icons.lock,
                                      obscureText: true),
                                  SizedBox(height: 20.0),
                                  _buildTextField(
                                      controller: _confirmPasswordController,
                                      labelText: 'Confirm Password',
                                      icon: Icons.lock,
                                      obscureText: true),
                                  SizedBox(height: 20.0),
                                  _buildTextField(
                                      controller: _nameController, labelText: 'Name', icon: Icons.person),
                                  SizedBox(height: 20.0),
                                  _buildTextField(
                                      controller: _phoneController, labelText: 'Phone', icon: Icons.phone),
                                  SizedBox(height: 20.0),
                                  _buildTextField(
                                      controller: _cityController, labelText: 'City', icon: Icons.location_city),
                                  SizedBox(height: 20.0),
                                  _buildTextField(
                                      controller: _stateController, labelText: 'State', icon: Icons.map),
                                  SizedBox(height: 20.0),
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage:
                                          _profileImage != null ? FileImage(_profileImage!) : null,
                                      child: _profileImage == null
                                          ? Icon(Icons.camera_alt, size: 50.0)
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            if (isLogin) {
                              signInWithEmailAndPassword();
                            } else {
                              createUserWithEmailAndPassword();
                            }
                          },
                          child: Text(isLogin ? 'Login' : 'Sign Up'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffE0BA59),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(isLogin ? 'Create an account' : 'Already have an account? Login'),
                        ),
                        if (!isLogin)
                          TextButton(
                            onPressed: resendVerificationEmail,
                            child: Text('Resend Verification Email'),
                          ),
                      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      obscureText: obscureText,
    );
  }
}
