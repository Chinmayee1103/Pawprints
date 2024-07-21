import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption/auth.dart';
import 'package:pet_adoption/ChoicePage.dart';
import 'package:pet_adoption/First.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage'; // Correctly defined static ID

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  String _errorMessage = '';
  bool isLogin = true;

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      _errorMessage = '';
    });
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => First()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred.';
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
  setState(() {
    _errorMessage = '';
  });

  // Validate input fields
  if (_emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _nameController.text.isEmpty ||
      _phoneController.text.isEmpty ||
      _cityController.text.isEmpty ||
      _stateController.text.isEmpty) {
    setState(() {
      _errorMessage = 'Please fill in all fields.';
    });
    return;
  }

  try {
    User? user = await Auth().createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
        phone: _phoneController.text,
        city: _cityController.text,
        state: _stateController.text,
      
    );
    if (user != null) {
      // Save additional user details to Firestore
      await Auth().updateUserDetails(
        uid: user.uid,
        email: _emailController.text,
        name: _nameController.text,
        phone: _phoneController.text,
        city: _cityController.text,
        state: _stateController.text,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to the LoginPage after a short delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.popUntil(context, ModalRoute.withName(LoginPage.id));
      });
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      _errorMessage = e.message ?? 'An error occurred.';
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
                  Text(
                    isLogin ? 'Login' : 'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                  SizedBox(height: 20.0),
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
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 10.0),
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
                          height: 30.0,
                          width: 30.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? 'Create Account' : 'Click here to login after registering',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
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
