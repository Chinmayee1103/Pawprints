import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption/OrgFirstPage.dart';
import 'package:pet_adoption/auth1.dart';
import 'ChoicePage.dart';

class OrgLoginPage extends StatefulWidget {
  static const String id = 'OrgLoginPage';

  @override
  _OrgLoginPageState createState() => _OrgLoginPageState();
}

class _OrgLoginPageState extends State<OrgLoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _errorMessage = '';
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
          MaterialPageRoute(builder: (context) => OrgFirstPage()),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      setState(() {
        _errorMessage = 'No user found for that email.';
      });
    } else if (e.code == 'wrong-password') {
      setState(() {
        _errorMessage = 'Wrong password provided.';
      });
    } else if (e.code == 'user-disabled') {
      setState(() {
        _errorMessage = 'User account has been disabled.';
      });
    // } else if (e.code == 'too-many-requests') {
    //   setState(() {
    //     _errorMessage = 'Too many requests. Please try again later.';
    //   });
    // } else {
    //   setState(() {
    //     _errorMessage = 'An error occurred. Please try again.';
    //   });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'An unexpected error occurred. Please try again.';
    });
  }
}

  Future<void> createUserWithEmailAndPassword() async {
  setState(() {
    _errorMessage = '';
  });

  if (_emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _nameController.text.isEmpty ||
      _contactNumberController.text.isEmpty ||
      _addressController.text.isEmpty) {
    setState(() {
      _errorMessage = 'Please fill in all fields.';
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
      await Auth1.addOrganization(
        oname: _nameController.text,
        oemail: _emailController.text,
        contactNumber: _contactNumberController.text,
        address: _addressController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChoicePage()),
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


  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordStrong(String password) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> signInWithGoogle() async {
    // Implement Google Sign-In logic here
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
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
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
                          'Organization Login',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Together, we can turn "Once upon a time" into "Happily ever after" for every pet in need.',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                        if (!isLogin) ...[
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Organization Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.business),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextField(
                            controller: _contactNumberController,
                            decoration: InputDecoration(
                              labelText: 'Contact Number',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20.0),
                          TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 50.0,
                              vertical: 15.0,
                            ),
                            textStyle: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(height: 10.0),
                        // Google Sign-In Button
                        GestureDetector(
                          onTap: signInWithGoogle,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/google.png', // Ensure you have the google.png asset
                                  height: 20.0,
                                ),
                                SizedBox(width: 10.0),
                                Text('Sign in with Google'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        // Toggle between Login and Register
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                              _errorMessage = '';
                            });
                          },
                          child: Text(
                            isLogin ? 'Create an account' : 'Already have an account?',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16.0,
                            ),
                          ),
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
}
