import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product Details'),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 500,
            right: -105,
            child: Container(
              width: 615,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffFDF967)
                    .withOpacity(0.6), // Semi-transparent white
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 0), // Padding for the image
                  child: Image.network(
                    product['image'] ??
                        'https://dummyimage.com/150x150/000/fff',
                    height: 250,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    product['name'] ?? 'No Name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  product['price'] != null
                      ? '\$${product['price']}'
                      : 'No Price Available',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                SizedBox(height: 8),
                Text(
                  product['description'] ?? 'No Description Available',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
