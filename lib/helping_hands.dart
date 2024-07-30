// helping_hands.dart
import 'package:flutter/material.dart';
import 'package:pet_adoption/SocialMedia.dart';
// import 'package:pet_adoption/socialmedia.dart';
//import 'package:pet_adoption/socialmedia.dart';

class HelpingHands extends StatelessWidget {
  const HelpingHands({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Helping Hands'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SocialMedia()),
            );
          },
          child: Text('Go to Social Media'),
        ),
      ),
    );
  }
}
