import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatHealthPage extends StatelessWidget {
  static const String id = 'cat_health_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cat Health',
          style: GoogleFonts.pacifico(
            fontSize: 24.0,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'This is the Cat Health Page',
          style: GoogleFonts.roboto(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
