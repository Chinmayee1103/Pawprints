import 'package:flutter/material.dart';

class CatPage extends StatelessWidget {
  const CatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Page'),
      ),
      body: Center(
        child: Text('Welcome to the Cat Page'),
      ),
    );
  }
}
