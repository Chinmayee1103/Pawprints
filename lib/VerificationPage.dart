import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption/loginpage.dart';
import 'package:lottie/lottie.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationSuccessPage(),
          ),
        );
      } else {
        // Keep checking every 3 seconds until verified
        Future.delayed(Duration(seconds: 3), _checkEmailVerification);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class RegistrationSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6C953), // Set background color here
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/Animation - 1700733826355.json', // Path to your Lottie file
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Container(
              width: 200, // Adjust width as needed
              height: 50, // Adjust height as needed
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Optional: Rounded corners
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0), // Adjust padding
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Go to Login Page',
                  style: TextStyle(fontSize: 16), // Adjust text size if needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
