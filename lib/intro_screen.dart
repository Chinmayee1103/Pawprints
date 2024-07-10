import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pet_adoption/First.dart';
import 'package:pet_adoption/loginpage.dart';

class intro_screen extends StatefulWidget {
  const intro_screen({super.key});

  @override
  _intro_screenState createState() => _intro_screenState();
}

class _intro_screenState extends State<intro_screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6C953),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/paws.png',
              height: 300,
              width: 300,
            ),
            SizedBox(height: 20), // Add some space between the image and text
            Text(
              'PawPrints',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: intro_screen(),
  ));
}
