import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_adoption/Shop/ProductDetailsPage.dart';

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
      if (snapshot.docs.isEmpty) {
        print('No products found');
        return [];
      }

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
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(15.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.6, // Adjust the aspect ratio here
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final imageUrl = product['image'] ??
                          'https://dummyimage.com/150x150/000/fff';
                      final name = product['name'] ?? 'Unknown';
                      final price = formatPrice(product['price']);
                      final description =
                          product['description'] ?? 'No description available.';
                      final rating = product['rating'] ?? 0.0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                product: product,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 6.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Container(
                                  height: 150, // Set the height of the image
                                  width:
                                      140, // Set the width to take the full width of the card
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0), // Add top padding
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                              child: Icon(Icons.error,
                                                  color: Colors.red));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      price,
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          Icons.star,
                                          color: i < rating
                                              ? Colors.amber
                                              : Colors.grey,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
