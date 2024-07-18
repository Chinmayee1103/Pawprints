import 'package:flutter/material.dart';

class DogPage extends StatelessWidget {
  const DogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Page'),
      ),
      body: Center(
        child: Text('Welcome to the Dog Page'),
      ),
    );
  }
}
