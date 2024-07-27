import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopNowPage extends StatelessWidget {
  static const String id = 'shop_now_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop Now',
          style: GoogleFonts.pacifico(fontSize: 24.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exclusive Deals & Products!',
              style: GoogleFonts.roboto(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Example List Items
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    title: Text('Product 1'),
                    subtitle: Text('Description of Product 1'),
                    trailing: Text('\$19.99'),
                    onTap: () {
                      // Handle product tap
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    title: Text('Product 2'),
                    subtitle: Text('Description of Product 2'),
                    trailing: Text('\$29.99'),
                    onTap: () {
                      // Handle product tap
                    },
                  ),
                  // Add more ListTile widgets as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
