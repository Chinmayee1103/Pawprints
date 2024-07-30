import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatAccessPage extends StatelessWidget {
  static const String id = 'cat_access_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cat Accessories',
          style: GoogleFonts.pacifico(
            fontSize: 24.0,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'This is the Cat Accessories Page',
          style: GoogleFonts.roboto(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
