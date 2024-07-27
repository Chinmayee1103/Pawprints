import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DogFood extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchDogFoodProducts() async {
    final firestore = FirebaseFirestore.instance;
    try {
      print('Fetching dog food products...');
      final snapshot = await firestore
          .collection('ecommerce')
          .doc('dogshopping')
          .collection('dogfood')
          .get();

      print('Documents fetched: ${snapshot.docs.length}');
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching dog food products: $e');
      return [];
    }
  }

  String formatPrice(dynamic price) {
    if (price is double) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price is String) {
      try {
        final parsedPrice = double.tryParse(price) ?? 0.0;
        return '\$${parsedPrice.toStringAsFixed(2)}';
      } catch (e) {
        print('Error parsing price: $e');
        return '\$0.00';
      }
    }
    return '\$0.00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Bark-Worthy Bites!',
          style: GoogleFonts.playfairDisplay(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDogFoodProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching data: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          }

          final products = snapshot.data!;

          return Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Color(0xFFFEFF66),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //SizedBox(height: 35),

                          // ClipRRect(
                          //   borderRadius: BorderRadius.vertical(
                          //     top: Radius.circular(16),
                          //   ),
                          //   child: Center(
                          //     child: Image.network(
                          //       product['image'] ??
                          //           'https://firebasestorage.googleapis.com/v0/b/pet-adoption-and-care-ed50c.appspot.com/o/product1.jpeg?alt=media&token=68c6f8ba-85e7-41d9-87a7-a6912d17c668',
                          //       width: 100,
                          //       height: 100,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'] ?? 'Product Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  formatPrice(product['price']),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < (product['rating'] ?? 0)
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 16,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
