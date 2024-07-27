import 'package:flutter/material.dart';

class CatShoppingPage extends StatelessWidget {
  static const String id = 'cat_shopping_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Shopping'),
      ),
      body: Center(
        child: Text('Welcome to the Cat Shopping Page!'),
      ),
    );
  }
} //Purrfect Finds!
