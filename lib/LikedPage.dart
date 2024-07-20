import 'package:flutter/material.dart';

class LikedPage extends StatelessWidget {
  const LikedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Like Page'),
      ),
      body: Center(
        child: Text('Welcome to the Like Page'),
      ),
    );
  }
}
