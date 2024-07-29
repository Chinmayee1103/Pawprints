import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:pet_adoption/AdoptionPage.dart';
import 'package:pet_adoption/ChoicePage.dart';
import 'package:pet_adoption/loginpage.dart';
import 'package:pet_adoption/ECommercePage.dart';

class intro_screen extends StatefulWidget {
  const intro_screen({Key? key}) : super(key: key);

  @override
  _intro_screenState createState() => _intro_screenState();
}

class _intro_screenState extends State<intro_screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EcommercePage()),
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
              style: GoogleFonts.holtwoodOneSc(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            SizedBox(
                height:
                    20), // Add space between PawPrints and the animated text
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Forever Homes, Eternal Care',
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  speed: Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
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
