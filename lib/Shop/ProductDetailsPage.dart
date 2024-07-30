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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  bottom: 320,
                  right: -100,
                  child: Container(
                    width: 615,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffFDF967)
                          .withOpacity(0.6), // Semi-transparent color
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                      100.0), // Padding for the main content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 0), // Padding for the image
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
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              width: 300, // Full width
              height: 55, // Height for Add to Cart
              padding: EdgeInsets.symmetric(
                  vertical: 8.0), // Padding inside the container
              decoration: BoxDecoration(
                color: Color(0xFFFBEC63), // Color for Add to Cart
                borderRadius: BorderRadius.circular(25.0), // Rounded corners
              ),
              child: TextButton(
                onPressed: () {
                  // Add to Cart action
                },
                child: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ), // Space between the containers
          Padding(
            padding: const EdgeInsets.only(bottom: 45),
            child: Container(
              width: 300, // Full width
              height: 55, // Height for Order
              padding: EdgeInsets.symmetric(
                  vertical: 13.0), // Padding inside the container
              decoration: BoxDecoration(
                color: Color(0xFFF7CF56), // Color for Order
                borderRadius: BorderRadius.circular(25.0), // Rounded corners
              ),
              child: Text(
                'Order',
                style: TextStyle(color: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 16), // Extra space at the bottom
        ],
      ),
    );
  }
}
